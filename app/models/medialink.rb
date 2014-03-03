class Medialink < ActiveRecord::Base
  attr_accessible :url, :title, :description
  belongs_to :profile
end
