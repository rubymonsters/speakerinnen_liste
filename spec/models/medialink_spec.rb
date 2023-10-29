describe 'medialink', type: :model do
  let(:medialink) { FactoryBot.build(:medialink) }

  describe '#find_youtube_id' do
    it 'in www.youtu.be/234dgf' do
      medialink.url = "www.youtu.be/234dgf"
      expect(medialink.find_youtube_id).to eq("234dgf")
    end

    it 'in www.youtu.be/276d?si=xx' do
      medialink.url = "www.youtu.be/276d?si=xx"
      expect(medialink.find_youtube_id).to eq("276d")
    end

    it 'in www.youtu.be/27-6d?si=xx' do
      medialink.url = "www.youtu.be/27-6d?si=xx"
      expect(medialink.find_youtube_id).to eq("27-6d")
    end

    it 'in https://www.youtube.com/watch?v=3Q8D4' do
      medialink.url = "https://www.youtube.com/watch?v=3Q8D4"
      expect(medialink.find_youtube_id).to eq("3Q8D4")
    end

    it 'in http://youtube.com' do
      medialink.url = "http://youtube.com"
      expect(medialink.find_youtube_id).to be nil
    end

    it 'in https://www.youtube.com/playlist?list=PLjQo0sojbbxWcy_byqkbe7j3boVTQurf9' do
      medialink.url = "https://www.youtube.com/playlist?list=PLjQo0sojbbxWcy_byqkbe7j3boVTQurf9"
      expect(medialink.find_youtube_id).to be nil

    end
  end

  describe '#youtube_thumbnail_url' do
    it 'creates a image url' do
      medialink.url = "www.youtu.be/276d?si=xx"
      youtube_url = "https://img.youtube.com/vi/276d/mqdefault.jpg"
      expect(medialink.youtube_thumbnail_url).to eq(youtube_url)
    end

    it 'returns nil when there is no youtube id in the url' do
      medialink.url = "www.youtu.be"
      expect(medialink.youtube_thumbnail_url).to be nil
    end
  end
end
