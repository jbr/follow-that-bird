begin
  require File.instance_eval { expand_path join(dirname(__FILE__), '..', 'vendor', 'gems', 'environment')}
rescue LoadError
  puts "Bundling Gems\n\nHang in there, this only has to happen once...\n\n"
  system 'gem bundle'
  retry
end

Bundler.require_env :test

$:.unshift File.instance_eval { expand_path join(dirname(__FILE__), "..", "lib") }
require 'test/unit'


class Test::Unit::TestCase
  include TestRig
end
