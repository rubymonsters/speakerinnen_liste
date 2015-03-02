class ProfilesSearch

  def initialize(query)
    @quick = query[:quick]
    @query = query
  end

  def results
    return quick_search_result if @quick
    detailed_search_result
  end

  private

  def quick_search_result
    return Profile.none if @quick.blank?
    Profile
      .includes(taggings: :tag)
      .references(:tag)
      .where(sql_string, query: "%#{@quick}%")
  end

  def detailed_search_result
    Profile
      .where('city ILIKE :city', city: "%#{@query[:city]}%")
  end

  def sql_string
    'firstname ILIKE :query OR lastname ILIKE :query OR twitter ILIKE :query OR tags.name ILIKE :query'
  end

end
