require 'spec_helper'

describe 'tags', type: :model do
  let!(:gertrud) { FactoryGirl.create(:published, firstname: 'Gertrud', lastname: 'Mueller') }
  let!(:claudia) { FactoryGirl.create(:published, firstname: 'Claudia', email: 'claudia@test.de') }

  before :each do
    gertrud.topic_list.add('obst')
    gertrud.save!

    claudia.topic_list.add('#obst')
    claudia.save!
  end

  it 'merging two tags keeps the taggings' do
    gertrud = Profile.where(firstname: 'Gertrud').first
    claudia = Profile.where(firstname: 'Claudia').first

    #ActsAsTaggableOn::Tagging.all.each do | tagging |
      #puts "tag id: #{tagging.tag_id} taggable id: #{tagging.taggable_id}"
    #end

    p "obst thinks: " +  ActsAsTaggableOn::Tag.where(name: 'obst').first.taggings_count.to_s
    p "#obst thinks: " + ActsAsTaggableOn::Tag.where(name: '#obst').first.taggings_count.to_s

    p "---"

    tag = ActsAsTaggableOn::Tag.where(name: 'obst').first
    wrong_tag = ActsAsTaggableOn::Tag.where(name: '#obst').first
    tag.merge(wrong_tag)

    #ActsAsTaggableOn::Tagging.all.each do | tagging |
      #puts "tag id: #{tagging.tag_id} taggable id: #{tagging.taggable_id}"
    #end

    p " After merging obst thinks: " +  ActsAsTaggableOn::Tag.where(name: 'obst').first.taggings_count.to_s

    expect(ActsAsTaggableOn::Tag.count).to eq 1
    expect(ActsAsTaggableOn::Tagging.count).to eq 2

    gertrud.topic_list.remove('obst')
    gertrud.save!

    p " After deleting obst thinks: " +  ActsAsTaggableOn::Tag.where(name: 'obst').first.taggings_count.to_s

    expect(ActsAsTaggableOn::Tag.count).to eq 1
    expect(ActsAsTaggableOn::Tagging.count).to eq 1

    #ActsAsTaggableOn::Tagging.all.each do | tagging |
      #puts "tag id: #{tagging.tag_id} taggable id: #{tagging.taggable_id}"
    #end
    expect(ActsAsTaggableOn::Tag.count).to eq 1
  end
end
