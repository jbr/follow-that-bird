require File.instance_eval { expand_path join(dirname(__FILE__), 'test_helper') }
require 'freighthopper'

class HashTest < Test::Unit::TestCase
  context 'map_keys' do
    should 'replace keys with their mapped replacement' do
      base = {:hello => :world}
      expected = {:howdy => :world}
      assert_equal expected, base.map_keys(:hello => :howdy)
    end
    
    should 'not modify keys that are not specified' do
      base = {:a => 1, :b => 2}
      mapping = {:a => :hello}
      expected = {:hello => 1, :b => 2}
      
      assert_equal expected, base.map_keys(mapping)
    end
    
    should 'ignore mappings that do not exist' do
      base = {:a => 1, :b => 2}
      mapping = {:q => :r}

      assert_equal base, base.map_keys(mapping)
    end
  end
end