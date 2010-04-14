require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'rake/clean'

desc 'Default: run unit tests.'
task :default => :test

begin
  require 'jeweler'
  Jeweler::Tasks.new do |jewel|
    jewel.name        = 'validates_existence'
    jewel.summary     = 'Validates Rails model belongs_to association existence.'
    jewel.email       = ['tanel.suurhans@perfectline.ee', 'tarmo.lehtpuu@perfectline.ee']
    jewel.homepage    = 'http://github.com/perfectline/validates_existence/tree/master'
    jewel.description = 'A library for validating model association existence.'
    jewel.authors     = ["Tanel Suurhans", "Tarmo Lehtpuu"]
    jewel.files       = FileList["rails/*.rb", "lib/**/*.rb", "*.rb", "MIT-LICENCE", "README.markdown"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

desc 'Test the plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ValidatesExistence'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.markdown')
  rdoc.rdoc_files.include('lib/**/*.rb')
end