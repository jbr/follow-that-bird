require File.instance_eval { expand_path join(dirname(__FILE__), 'test_helper') }
require 'freighthopper'

class ObjectTest < Test::Unit::TestCase
  context 'soft_send' do
    should 'send the method if the object responds to it' do
      assert_equal 1, [1].soft_send(:first)
    end
    
    should 'return nil if the object does not' do
      assert_nil 5.soft_send(:hello)
    end
    
    should 'pass args' do
      assert_equal 10, 5.soft_send(:*, 2)
    end
  end
  
  context 'or_if_blank' do
    should 'return nil if there is no block and the argument is nil' do
      assert_nil "".or_if_blank(nil)
    end
    
    should 'return the callee if it is not blank' do
      assert_equal "hello", "hello".or_if_blank(5)
    end
    
    should 'return the first arg if the callee is blank' do
      assert_equal 5, "".or_if_blank(5)
    end
    
    should 'accept a block' do
      assert_equal 5, "".or_if_blank{5}
    end
  end
  
  context 'is_one_of?' do
    should 'check if the object is one of the arguments' do
      assert "hello".is_one_of?(Fixnum, Symbol, Proc, String)
    end
    
    should 'work with an array as well' do
      assert :symbol.is_one_of?([Fixnum, Symbol])
    end
    
    should 'return false if there is no match' do
      assert_not :symbol.is_one_of?(Proc, String)
    end
  end
end
