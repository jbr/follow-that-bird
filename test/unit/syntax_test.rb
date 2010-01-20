require 'test_helper'

class SyntaxTest < ActiveSupport::TestCase
  context "with a simple syntax" do
    setup {@syntax = Syntax.new :format => "#loc {{location}} #needs {{need}}"}
    
    should 'be valid' do
      assert_valid @syntax
    end
    
    context 'keys' do
      should 'be "location"' do
        assert_keys [:location, :need], @syntax
      end
    end
    
    context 'as regex' do
      should 'be the same with no curlies' do
        assert_as_regex /#loc (.+) #needs (.+)/, @syntax
      end
    end
    
    context 'on a match' do
      setup {@match = @syntax.match("#loc x, y #needs code")}
      should 'have an array of keys and matches' do
        expected_hash = {:location => "x, y", :need => "code"}
        assert_equal expected_hash, @match
      end
    end
  end
  
  context 'with a syntax that duplicates keys' do
    setup {@syntax = Syntax.new :format => "{{test}} {{test}}"}
    should 'not be valid' do
      assert_not_valid @syntax
      assert_equal "cannot contain duplicate keys", @syntax.errors.on(:format)
    end
  end
end
