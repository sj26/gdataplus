require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "gdataplus"
    gem.summary = %Q{Extending GData to provide a nicer, ruby-like interface to certain APIs..}
    gem.email = "sj26@sj26.com"
    gem.homepage = "http://github.com/sj26/gdataplus"
    gem.authors = ["Samuel Cochran"]
    
    gem.add_dependency 'gdata'
    gem.add_dependency 'nokogiri'
    gem.add_dependency 'activesupport'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end
