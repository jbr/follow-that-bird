require File.instance_eval { expand_path join(dirname(__FILE__), 'test_helper') }
require 'freighthopper'

class DefineAndAliasTest < Test::Unit::TestCase
  class SomeClass
    attr_reader :cache
    def foo() 5 end

    define_and_alias(:foo, :bar) {foo_without_bar + 5}
  
    def even?(number) number % 2 == 0 end
    
    define_and_alias :even?, :caching do |number|
      (@cache ||= {})[number] ||= even_without_caching?(number)
    end
  end
  
  context 'with a SomeClass' do
    setup {@object = SomeClass.new}

    should 'respond to foo_with_bar' do
      assert @object.respond_to?('foo_with_bar')
    end

    should 'respond to foo_without_bar' do
      assert @object.respond_to?('foo_without_bar')
    end

    should 'return 5 for foo_without_bar' do
      assert_foo_without_bar 5, @object
    end

    should 'return 10 for foo' do
      assert_foo 10, @object
    end

    should 'handle questionmark methods' do
      %w(even? even_without_caching? even_with_caching?).each do |method|
        assert @object.respond_to?(method)
      end
    end
  
    should 'pass arguments' do
      assert @object.even?(4)
      assert_length 1, @object.cache
    end
  end
end