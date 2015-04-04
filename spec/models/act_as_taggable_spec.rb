require 'spec_helper'

describe 'tags', type: :model do
  let!(:gertrud) { FactoryGirl.create(:published, firstname: 'Gertrud', lastname: 'Mueller') }
  let!(:claudia) { FactoryGirl.create(:published, firstname: 'Claudia', email: 'claudia@test.de') }
  let!(:inge) { FactoryGirl.create(:published, firstname: 'Inge', email: 'inge@test.de') }

  before :each do
    gertrud.topic_list.add('media')
    gertrud.save!

    claudia.topic_list.add('#media')
    claudia.save!

    inge.topic_list.add('#media')
    inge.save!
  end

  context 'merging two tags adds the tags_count of the tags model we keep' do

    it 'and so the tag itself stays after one of the profiles deletes that tag' do
      expect(ActsAsTaggableOn::Tag.count).to eq 2
      expect(ActsAsTaggableOn::Tagging.count).to eq 3

      correct_tag = ActsAsTaggableOn::Tag.where(name: 'media').first
      wrong_tag   = ActsAsTaggableOn::Tag.where(name: '#media').first
      correct_tag.merge(wrong_tag)

      expect(ActsAsTaggableOn::Tag.count).to eq 1
      expect(ActsAsTaggableOn::Tagging.count).to eq 3

      gertrud.topic_list.remove('media')
      gertrud.save!

      expect(ActsAsTaggableOn::Tag.count).to eq 1
      expect(ActsAsTaggableOn::Tagging.count).to eq 2
    end
  end
end
