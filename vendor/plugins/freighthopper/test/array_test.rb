require File.instance_eval { expand_path join(dirname(__FILE__), 'test_helper') }
require 'freighthopper'

class ArrayTest < Test::Unit::TestCase
  context 'singular' do
    should 'return the singular object if there is indeed only one' do
      assert_singular 5, [5]
    end
    
    should 'return nil if the array is empty' do
      assert_singular nil, []
    end
    
    should 'return nil if the array has > 1 item' do
      assert_singular nil, [1, 2]
    end
  end
  
  context 'singular questionmark' do
    should 'return true if the array has only one member' do
      assert_singular [5]
    end
    
    should 'return false if the array is empty' do
      assert_not_singular []
    end
    
    should 'return false if the array has more than one member' do
      assert_not_singular [1, 2]
    end
  end
  
  context 'singular bang' do
    should 'return the item if there is just one' do
      assert_equal 5, [5].singular!
    end
    
    should 'raise if there are no items' do
      e = assert_raise(RuntimeError){ [].singular! }
      assert_message 'not singular', e
    end

    should 'raise if there are more than one item' do
      e = assert_raise(RuntimeError){ [1, 2].singular! }
      assert_message 'not singular', e
    end
  end
end