require File.instance_eval { expand_path join(dirname(__FILE__), 'test_helper') }
require 'freighthopper'

class DefineAndAliasTest < Test::Unit::TestCase
  class SomeClass
    attr_reader :last_method_missing, :last_args
    lazy_alias :this_method_is_called, :this_hits_method_missing
    
    def method_missing(*args)
      @last_method_missing = args.shift
      @last_args = args
    end
  end
  
  context 'with a SomeClass' do
    setup {@object = SomeClass.new}

    should 'respond to this_method_is_called' do
      assert @object.respond_to?(:this_method_is_called)
    end
    
    context "after calling this_method_is_called" do
      setup {@object.this_method_is_called :arg1, :arg2}
      
      should 'call whatever method is the second argument' do
        assert_last_method_missing :this_hits_method_missing, @object
      end
      
      should 'pass through args' do
        assert_last_args [:arg1, :arg2], @object
      end
    end
  end
end