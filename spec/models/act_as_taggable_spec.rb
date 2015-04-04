require 'spec_helper'

describe 'tags', type: :model do
  let!(:gertrud) { FactoryGirl.create(:published, firstname: 'Gertrud', lastname: 'Mueller') }
  let!(:claudia) { FactoryGirl.create(:published, firstname: 'Claudia', email: 'claudia@test.de') }
  let!(:inge) { FactoryGirl.create(:published, firstname: 'Inge', email: 'inge@test.de') }

  before :each do
    gertrud.topic_list.add('obst')
    gertrud.save!

    claudia.topic_list.add('#obst')
    claudia.save!

    inge.topic_list.add('#obst')
    inge.save!
  end

  it 'merging two tags keeps the taggings' do
    gertrud = Profile.where(firstname: 'Gertrud').first
    claudia = Profile.where(firstname: 'Claudia').first
    inge    = Profile.where(firstname: 'inge').first

    ActsAsTaggableOn::Tagging.all.each do | tagging |
      puts "tag id: #{tagging.tag_id} taggable id: #{tagging.taggable_id}"
    end

    p "obst thinks: " +  ActsAsTaggableOn::Tag.where(name: 'obst').first.taggings_count.to_s
    p "#obst thinks: " + ActsAsTaggableOn::Tag.where(name: '#obst').first.taggings_count.to_s
    p "---"
    p "merging"
    p "---"

    expect(ActsAsTaggableOn::Tag.count).to eq 2
    expect(ActsAsTaggableOn::Tagging.count).to eq 3

    correct_tag = ActsAsTaggableOn::Tag.where(name: 'obst').first
    wrong_tag   = ActsAsTaggableOn::Tag.where(name: '#obst').first
    correct_tag.merge(wrong_tag)

    ActsAsTaggableOn::Tagging.all.each do | tagging |
      puts "tag id: #{tagging.tag_id} taggable id: #{tagging.taggable_id}"
    end

    p " After merging obst thinks: " +  ActsAsTaggableOn::Tag.where(name: 'obst').first.taggings_count.to_s

    expect(ActsAsTaggableOn::Tag.count).to eq 1
    expect(ActsAsTaggableOn::Tagging.count).to eq 3

    gertrud.topic_list.remove('obst')
    gertrud.save!

    p "---"
    p "delete gertruds topic"
    p "---"
    p " After deleting obst thinks: " +  ActsAsTaggableOn::Tag.where(name: 'obst').first.taggings_count.to_s

    expect(ActsAsTaggableOn::Tag.count).to eq 1
    expect(ActsAsTaggableOn::Tagging.count).to eq 2

    ActsAsTaggableOn::Tagging.all.each do | tagging |
      puts "tag id: #{tagging.tag_id} taggable id: #{tagging.taggable_id}"
    end
  end
end
