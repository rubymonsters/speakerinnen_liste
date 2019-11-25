# frozen_string_literal: true

class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :firstname, :lastname, :city, :country, :twitter, :created_at,
             :updated_at, :website, :website_2, :website_3, :profession, :topics, :bio, :main_topic

  has_many :medialinks

  def topics
    object.topics.map(&:name)
  end

  def bio
    object.bio_translations
  end

  def main_topic
    object.main_topic_translations
  end

  def medialinks
    object.medialinks
  end
end
