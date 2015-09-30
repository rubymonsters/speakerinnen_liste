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

    gertrud.topic_list.remove('media')
    gertrud.save!

    expect(ActsAsTaggableOn::Tag.count).to eq 1
    expect(ActsAsTaggableOn::Tagging.count).to eq 2
  end
end
