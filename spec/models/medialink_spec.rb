describe 'medialink', type: :model do
  context 'extract the youtube id' do
    let(:medialink) { FactoryBot.build(:medialink) }

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

    it 'creates a image url' do
      medialink.url = "www.youtu.be/276d?si=xx"
      youtube_url = "https://img.youtube.com/vi/276d/mqdefault.jpg"
      expect(medialink.youtube_thumbnail_url).to eq(youtube_url)
    end
  end
end
