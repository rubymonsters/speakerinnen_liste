# frozen_string_literal: true

class Message
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :name, :email, :subject, :body

  validates :name, :email, :subject, :body, presence: true
  validates :email, format: { with: /.+@.+\..+/ }, allow_blank: false

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end
