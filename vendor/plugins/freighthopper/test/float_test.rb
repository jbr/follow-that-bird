require File.instance_eval { expand_path join(dirname(__FILE__), 'test_helper') }
require 'freighthopper'

class FloatTest < Test::Unit::TestCase
  context 'to_s with format' do
    should 'work as before' do
      assert_to_s '1.1', 1.1
    end
    
    should 'allow specification of a format string' do
      assert_equal "1.2", 1.23.to_s("%.1f")
    end
    
    should 'allow specification of a precision' do
      assert_equal '1.2', 1.23.to_s(1)
    end
  end
end