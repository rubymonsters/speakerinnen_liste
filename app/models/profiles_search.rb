class ProfilesSearch

  def initialize(query)
    @quick = query[:quick]
    @query = query
  end

  def results
    return quick_search_result if @quick
    detailed_search_result
  end

#only search in public profiles
  private

  def quick_search_result
    return Profile.none if @quick.blank?
    Profile
      .includes(taggings: :tag)
      .references(:tag)
      .where(sql_string, query: "%#{@quick}%")
  end

  def detailed_search_result
    p "city: #{@query[:city]}"
    p "languages: #{@query[:languages]}"
    p "name: #{@query[:name]}"
    p "twitter: #{@query[:twitter]}"
    Profile
      .where('city ILIKE :city', city: "%#{@query[:city]}%")
      .where('languages ILIKE :languages', languages: "%#{@query[:languages]}%")
      .where('firstname ILIKE :name OR lastname ILIKE :name', name: "%#{@query[:name]}%")
      .where('twitter ILIKE :twitter', twitter: "%#{@query[:twitter]}%")
  end

  def sql_string
    'firstname ILIKE :query OR lastname ILIKE :query OR twitter ILIKE :query OR tags.name ILIKE :query'
  end

end
