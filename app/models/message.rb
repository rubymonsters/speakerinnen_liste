class Message
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :name, :email, :subject, :body, HONEYPOT_EMAIL_ATTR_NAME

  validates :name, :email, :subject, :body, presence: true
  validates :email, format: { with: %r{.+@.+\..+} }, allow_blank: false

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end
