class ProfilesSearch

  def initialize(query)
    @quick = query[:quick]
    @query = query
  end

  def results
    search_result.is_published
  end

#only search in public profiles
  private

  def search_result
    return quick_search_result if @quick
    detailed_search_result
  end

  def quick_search_result
    return Profile.none if @quick.blank?
    Profile
      .includes(taggings: :tag)
      .references(:tag)
      .where(sql_string, query: "%#{@quick}%")
  end

  def detailed_search_result
    result = Profile
      .where('city ILIKE :city', city: "%#{@query[:city]}%")
      .where('firstname ILIKE :name OR lastname ILIKE :name', name: "%#{@query[:name]}%")
      .where('twitter ILIKE :twitter', twitter: "%#{@query[:twitter]}%")

    if @query[:languages].present?
      result = result
        .joins(:profile_languages).where('profile_languages.iso_639_1' => @query[:languages])
    end

    # to get the search for tags working, we had to add that if statement
    if @query[:topics].present?
      result = result
        .includes(taggings: :tag)
        .references(:tag)
        .where('tags.name ILIKE :topics', topics: "%#{@query[:topics]}%")
    end
    result
  end

  def sql_string
    'firstname ILIKE :query OR lastname ILIKE :query OR twitter ILIKE :query OR tags.name ILIKE :query'
  end

end
