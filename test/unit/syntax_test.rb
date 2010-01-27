require 'test_helper'

class SyntaxTest < ActiveSupport::TestCase
  context "with a simple syntax" do
    setup do
      @syntax = Syntax.create :format => "#loc {{location}} #needs {{need}}"
      Syntax.create :format => "#ruok {{name}}"
    end
    
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

    context 'tagging a tweet with a single syntax' do 
      setup do
        @tweet = Tweet.create :text => "#Haiti #loc port au prince #needs food #ignore this",
          :from_user => 'mt'
      end
      
      should 'produce taggings' do
        @syntax.create_tags_for @tweet
        assert_size 2, @tweet.taggings
      end
    end

    context 'tagging a tweet with a single syntax (nonmatching)' do 
      setup {@tweet = Tweet.create(:text => "#Haiti need help", :from_user => 'mt') }
      
      should 'not produce any taggings' do
        @syntax.create_tags_for @tweet
        assert_empty @tweet.taggings
      end
    end

    context 'tagging tweet against all syntaxes' do 
      setup {@tweet = Tweet.create(:text => "#ruok joe blow", :from_user => 'mt') }

      context 'after tagging' do
        setup {Syntax.tag @tweet}
        
        should 'create and associate one tagging' do
          assert_size 1, @tweet.taggings
        end
        
        should 'store the field on the tagging' do
          assert_field "name", @tweet.taggings.first
        end
        
        should 'store the matched value on the tagging' do
          assert_value "joe blow", @tweet.taggings.first
        end
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
