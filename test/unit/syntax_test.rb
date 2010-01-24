require 'test_helper'

class SyntaxTest < ActiveSupport::TestCase
  context "with a simple syntax" do
    setup {
      @syntax = Syntax.create :format => "#loc {{location}} #needs {{need}}"
      @syntax2 = Syntax.create :format => "#ruok {{name}}"
    }
    
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
      setup {@tweet = Tweet.create(:text => "#Haiti #loc port au prince #needs food #ignore this", :from_user => 'mt') }
      
      should 'produce taggings' do
        @syntax.build_tags(@tweet)
        assert_size(2, @tweet.taggings)
      end
    end

    context 'tagging a tweet with a single syntax (nonmatching)' do 
      setup {@tweet = Tweet.create(:text => "#Haiti need help", :from_user => 'mt') }
      
      should 'not produce taggings' do
        @syntax.build_tags(@tweet)
        assert_size(0, @tweet.taggings)
      end
    end

    context 'tagging tweet against all syntaxes' do 
      setup {@tweet = Tweet.create(:text => "#ruok joe blow", :from_user => 'mt') }
      should 'match only one syntax' do 
        Syntax.tag(@tweet)
        assert_size(1, @tweet.taggings)
        assert_equal("name", @tweet.taggings.first.field)
        assert_equal("joe blow", @tweet.taggings.first.value)
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
