require 'test_helper'

class HashtagTest < ActiveSupport::TestCase
  context 'with a few hashtags' do
    setup do
      %w(hello twitter world).each do |word|
        Hashtag.create! :tag => word
      end
    end
    
    should 'not allow a duplicate hashtag' do
      assert_not_valid Hashtag.new(:tag => "twitter")
    end
  end
  
  context "with an included and excluded hashtags" do 
    setup do 
      Hashtag.create! :tag => 'haiti', :include => true
      Hashtag.create! :tag => 'donate', :include => false
      Hashtag.create! :tag => 'support', :include => false      
    end
    
    should 'properly format hashtags as a search query' do 
      assert_equal '#haiti -donate -support', Hashtag.search_string
    end
  end
    
end
