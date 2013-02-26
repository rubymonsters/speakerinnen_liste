require 'rails/version'

if ['--version', '-v'].include?(ARGV.first)
  puts "Rails #{Rails::VERSION::STRING}"
  exit(0)
end

if ARGV.first != "new"
  ARGV[0] = "--help"
else
  ARGV.shift
  railsrc = File.join(File.expand_path("~"), ".railsrc")
  if File.exist?(railsrc)
    extra_args_string = File.open(railsrc).read
    extra_args = extra_args_string.split(/\n+/).map {|l| l.split}.flatten
    puts "Using #{extra_args.join(" ")} from #{railsrc}"
    ARGV << extra_args
    ARGV.flatten!
  end
end

require 'rubygems' if ARGV.include?("--dev")
require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Rails
  module Generators
    class AppGenerator
      # We want to exit on failure to be kind to other libraries
      # This is only when accessing via CLI
      def self.exit_on_failure?
        true
      end
    end
  end
end

Rails::Generators::AppGenerator.start
