# Rakefile
require 'rubygems'  
require 'rake'  
require 'echoe'  

require 'rake/testtask'
require 'rake/rdoctask'
 
Echoe.new('m', '0.0.1') do |p|  
  p.description     = "Rails 3 Framework inspired by Drupal"  
  p.url             = "http://github.com/dfurber/m"  
  p.author          = "David Furber"  
  p.email           = "dfurber@gorges.us"  
  p.ignore_pattern  = ["tmp/*", "script/*"]  
  p.dependencies = %w{meta_where devise compass haml cancan paperclip has_scope inherited_resources inherited_resources_views simple_form will_paginate ancestry symboltable dynamic_form exception_notification}
end  

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "m"
    gemspec.summary = "Rails 3 framework inspired Drupal + Rails best practices."
    gemspec.description = "Do all kinds of things."
    gemspec.email = "dfurber@gorges.us"
    gemspec.homepage = "http://github.com/dfurber/m"
    gemspec.authors = ["David Furber"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler -s http://gemcutter.org"
end

# uniquify.gemspec
Gem::Specification.new do |s|
  s.name        = "m"
  s.version     = "0.0.1"
  s.author      = "David Furber"
  s.email       = "dfurber@gorges.us"
  s.homepage    = "http://github.com/dfurber/m"
  s.summary = "Rails 3 framework inspired Drupal + Rails best practices."
  s.description = "Do all kinds of things."
  
  s.files        = Dir["{app,lib,public,test}/**/*"] + Dir["[A-Z]*"] + ["init.rb"]
  s.require_path = "lib"
  
  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.4"
end

