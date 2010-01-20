begin
  require "#{File.dirname(__FILE__)}/../vendor/bundler_gems/environment"
rescue LoadError
  puts "Bundling Gems\n\nHang in there, this only has to happen once...\n\n"
  system 'gem bundle'
  retry
end
