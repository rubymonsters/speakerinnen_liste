# frozen_string_literal: true

describe 'tags', type: :model do
  let!(:ada) { FactoryBot.create(:ada, firstname: 'Ada') }
  let!(:marie) { FactoryBot.create(:marie, firstname: 'Marie') }
  let!(:grace) { FactoryBot.create(:published_profile, firstname: 'Grace') }

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

  it 'forces tags to lowercase' do
    ada.topic_list.clear
    ada.topic_list.add('Juni')
    ada.save!
    expect(ada.topic_list.first).to eq('juni')
  end
end
