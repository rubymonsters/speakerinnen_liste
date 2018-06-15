# frozen_string_literal: true

desc 'find and count cities from profiles with missing countries'
task find_all_existing_cities: :environment do
  profiles_without_countries = Profile.is_published.where(country: nil).all
  profiles_with_countries = Profile.is_published.where.not(country: nil).all
  puts "There are #{Profile.is_published.count} approved profiles. #{profiles_without_countries.size} have no country"
  cities_from_profiles_without_countries = profiles_without_countries.map(&:city)
  counted_city_hash = Hash.new(0)
  cities_from_profiles_without_countries.each do |city|
    counted_city_hash[city] += 1
  end
  sorted_counted_city_hash = counted_city_hash.sort_by { |_city, count| count }
  # sorted_counted_city_hash.each do |city, count|
  # puts "#{count.to_s.rjust(3)} mal #{city}"
  # end
  puts sorted_counted_city_hash.select { |_city, count| count > 1 }.map(&:first).join(' ')
  city_to_country_mapping =
    {
      'DE' => %w[Leinfelden-Echterdingen Fürstenberg Munich Germany 10119 Greifswald Garmisch Frechen Lich Röthenbach hamburg Lennestadt berlin Kelkheim Trier Ahlen Bretzfeld Tölz Hürth Holzminden Gröbenzell Dorsten Hildesheim Friedrichshafen Ratingen Klosterneuburg Lachendorf Bensheim Eisenstadt Freudenberg Oldenburg Rottweil Klagenfurt Odenwald Deggendorf Coburg Westfalica Ruhrstadt Görlitz Gotha Kreuzberg Celle Euskirchen Emden Dielheim Wolfenbüttel Offenbach Plauen darmstadt Krefeld Dannenberg Schweinfurt Neustadt Remscheid Aschaffenburg Peter-Ording Lennstadt Lörrach Reutlingen Bamberg Gerolstein Oldenburg Holstein Lengenfeld Overath Cologne Wilhelmshaven Altdorf Memmingen Bottrop Limburg Giessen KelkheimTrier Koeln Bochum Wolfsburg Königstein Bayreuth Kornwestheim Mönchengladbach Wiehl Manching Ludwigsburg Bergisch Lohmar Magdeburg Halle Sinzig Gießen Aschersleben Bln Rheinberg Mainz Marburg Berlin Hamburg Ulm Rosenheim München Kaiserslautern Heilbronn Erfurt Wuppertal Nürnberg Würzburg Paderborn Ingolstadt Braunschweig Göttingen Köln Bonn Kassel Bremen Augsburg Frankfurt Regensburg Jena Osnabrück Heidelberg Mannheim Bielefeld Darmstadt Freiburg Potsdam Dresden Aachen Wiesbaden Münster Hannover Essen Bonn Dortmund Stuttgart Frankfurt Karlsruhe Frankfurt Düsseldorf Leipzig Köln München Tübingen],
      'AT' => %w[Dornbirn Krems wien Innsbruck Völs Bisamberg Wien Graz Linz Vienna Salzburg Birkfeld Johann],
      'AU' => %w[Melbourne Brisbane Sydney Canberra],
      'IE' => %w[Galway],
      'GR' => %w[Athens],
      'BR' => %w[Curitiba],
      'NO' => %w[Oslo Bergen],
      'MX' => %w[Mexico],
      'CH' => %w[Arosa Moritz Steckborn Winterthur Gallen Lenzburg Solothurn Zuerich Stans Baden Zurzach Geneva Zürich Lausanne Bern Hilterfingen Basel Luzern Zurich],
      'GB' => %w[London Leeds Glasgow Falmouth london Belfast],
      'US' => %w[Tallahassee California KCMO Paul Cleveland Denver Portland Clara Brooklyn Oakland NYC Vegas Boston Denver Francisco Angeles Seattle Chicago York Washington],
      'NL' => %w[Amsterdam Utrecht Groningen Rotterdam],
      'ES' => %w[Barcelona Palmas Madrid],
      'IN' => %w[Delhi Pune Bangalore],
      'AF' => %w[Kabul],
      'BE' => %w[Gent],
      'CD' => %w[Kinshasa],
      'CA' => %w[Montreal],
      'FR' => %w[Strasbourg Montpellier Grenoble],
      'FI' => %w[Hailuoto],
      'SE' => %w[Stockholm],
      'BA' => %w[sarajevo],
      'TN' => %w[Tunis],
      'MY' => %w[Jaya],
      'RU' => %w[Petersburg Moscow]
    }
  matched_profile_counter = 0
  unmatched_cities = []
  profiles_without_countries.each do |profile|
    profile_could_be_matched = false
    city_to_country_mapping.each do |country, cities|
      next unless matching_city = cities.find { |city| profile.city =~ /#{Regexp.quote(city)}/ }
      matched_profile_counter += 1
      profile_could_be_matched = true
      profile.update_attribute(:country, country)
      profile.save!
      # puts "#{country}: #{matching_city}"
    end
    unless profile_could_be_matched
      puts "unmatchde: ID: #{profile.id.to_s.rjust(5)} city: #{profile.city}" unless profile_could_be_matched
      unmatched_cities << profile.city
    end
  end
  puts "Profiles without countries: #{profiles_without_countries.size}"
  puts "Profiles with countries: #{profiles_with_countries.size}"
  puts "Updated Profiles: #{matched_profile_counter}"
  puts unmatched_cities.uniq.join(' ')
end
