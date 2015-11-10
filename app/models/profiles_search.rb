class ProfilesSearch

  def initialize(query)
    @quick = query[:quick]
    @query = query
  end

  def results
    search_result.is_published
  end

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
    return Profile.none if @query.values.all? &:blank?
    result = Profile
      .where('city ILIKE :city', city: "%#{@query[:city]}%")
      .where('firstname ILIKE :name OR lastname ILIKE :name', name: "%#{@query[:name]}%")
      .where('twitter ILIKE :twitter', twitter: "%#{@query[:twitter]}%")
    if @query[:languages].present?
      result = result
        .joins(:profile_languages).where('profile_languages.iso_639_1' => @query[:languages])
    end

    if @query[:languages].present? # && @query[:languages] =~ /[abc]{2}/
      result = result
        .where('languages ILIKE :iso_start OR
                languages ILIKE :iso OR
                languages ILIKE :en_name OR
                languages ILIKE :de_name OR
                languages ILIKE :own_name',
                SearchLanguages.search_strings(@query[:languages]))
    end
    # to get the search for tags working, we had to add that if statement
    if @query[:topics].present?
      result = result
        .includes(taggings: :tag)
        .references(:tag)
        .where('tags.name ILIKE :topics', topics: "%#{@query[:topics]}%")
    end
    result.uniq
  end

  def sql_string
    'firstname ILIKE :query OR lastname ILIKE :query OR twitter ILIKE :query OR tags.name ILIKE :query'
  end

end

