class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :firstname, :lastname, :city, :twitter, :created_at,
             :updated_at, :website, :topics, :picture, :bio, :main_topic

  has_many :medialinks

  def topics
    object.topics.map(&:name)
  end

  def picture
    object.picture.url
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
