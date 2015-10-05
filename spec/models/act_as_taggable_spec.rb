describe 'tags', type: :model do
  let!(:ada) { FactoryGirl.create(:published, firstname: 'Ada') }
  let!(:marie) { FactoryGirl.create(:published, firstname: 'Marie') }
  let!(:grace) { FactoryGirl.create(:published, firstname: 'Grace') }

  before :each do
    ada.topic_list.add('media')
    ada.save!

    marie.topic_list.add('#media')
    marie.save!

    grace.topic_list.add('#media')
    grace.save!
  end

  # our actsastaggable method "merging tags" did not work because we did not
  # increase the build in counter cache for taggings in the tag model
  # when counter cache reached zero the remaining tag was accidently deleted
  it 'merging two tags works' do
    expect(ActsAsTaggableOn::Tag.count).to eq 2
    expect(ActsAsTaggableOn::Tagging.count).to eq 3

    correct_tag = ActsAsTaggableOn::Tag.where(name: 'media').first
    wrong_tag   = ActsAsTaggableOn::Tag.where(name: '#media').first
    correct_tag.merge(wrong_tag)

    expect(ActsAsTaggableOn::Tag.count).to eq 1
    expect(ActsAsTaggableOn::Tagging.count).to eq 3

    ada.topic_list.remove('media')
    ada.save!

    expect(ActsAsTaggableOn::Tag.count).to eq 1
    expect(ActsAsTaggableOn::Tagging.count).to eq 2
  end
end
