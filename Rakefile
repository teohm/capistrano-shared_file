# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "capistrano-shared_file"
  gem.homepage = "http://github.com/teohm/capistrano-shared_file"
  gem.license = "MIT"
  gem.summary = %Q{Capistrano recipe to symlink shared files e.g. config/database.yml}
  gem.description = %Q{
    To use the recipe, add the following lines to config/deploy.rb: 
  
    #set :shared_files, %w(config/database.yml) # optional, as it's the default value
    require 'capistrano/shared_file'
  }
  gem.email = "teohuiming@gmail.com"
  gem.authors = ["teohm"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

task :default => :version

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "capistrano-shared_file #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
