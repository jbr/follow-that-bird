require File.instance_eval { expand_path join(dirname(__FILE__), 'test_helper') }
require 'freighthopper'

class StringTest < Test::Unit::TestCase
  context 'strip' do
    should 'still allow normal strip' do
      assert_strip "hello", " hello \t\n"
    end
    
    should 'also allow a string' do
      assert_equal "hello", "---hello---".strip("-")
    end
    
    should 'also allow a regular expression' do
      assert_equal "hello", "123hello456".strip(/[0-9]/)
    end
  end
  
  context 'division operator' do
    context 'with an even division' do
      should 'split the string into that many even strings' do
        divided = ('-' * 10) / 2
        assert_size 2, divided
        assert_equal [5, 5], divided.map{|s| s.length}
      end
    end
    
    context 'with an uneven division' do
      should 'take the difference out of the last one' do
        divided = ('-' * 10) / 3
        assert_size 3, divided
        assert_equal [4,4,2], divided.map(&:length)
      end
    end
  end
  
  context 'unindent' do
    should 'remove the least common leading whitespace' do
      unindented = (<<-END).unindent
        a
          b
            c
      END
      
      assert_equal "a\n  b\n    c", unindented
    end
    
    should 'replace tabs with tablength' do
      unindented = "\ttest\n\t\ttest".unindent :tablength => 4
      assert_equal "test\n    test", unindented
    end

    should 'replace tabs with tablength (defaulting to 2)' do
      unindented = "\ttest\n\t\ttest".unindent
      assert_equal "test\n  test", unindented
    end
  end
end