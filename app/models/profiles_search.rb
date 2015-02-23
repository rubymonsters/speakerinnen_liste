class ProfilesSearch

  def initialize(query)
    @query = query
  end

  def results
    Profile
      .includes(taggings: :tag)
      .references(:tag)
      .where(sql_string, query: "%#{@query}%")
  end

  private

  def sql_string
    'firstname ILIKE :query OR lastname ILIKE :query OR twitter ILIKE :query OR tags.name ILIKE :query'
  end

end
