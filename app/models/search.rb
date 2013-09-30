class Search < ActiveRecord::Base
  belongs_to :profile

  # Search records are never modified
  def readonly?
    true
  end
end
