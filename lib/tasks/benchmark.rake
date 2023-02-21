# frozen_string_literal: true

desc 'benchmarks two methods'
task benchmark: :environment do
  Benchmark.bmbm do |x|
    x.report("alt") { Search.new('social media').aggregations_hash }
    x.report("group")  { Search.new('social media').aggregations_hash_group  }
  end
end
