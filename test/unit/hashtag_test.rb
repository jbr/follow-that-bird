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
  
  context "with included and excluded hashtags" do 
    setup do 
      Hashtag.create! :tag => 'haiti', :include => true
      Hashtag.create! :tag => 'donate', :include => false
      Hashtag.create! :tag => 'support', :include => false
      Hashtag.create! :tag => "test", :include => true
    end
    
    context 'included named scope' do
      should 'have two hashtags, both of which are included' do
        assert_size 2, Hashtag.included
        assert Hashtag.included.all?(&:include?)
      end
    end
    
    context 'excluded named scope' do
      should 'have two hashtags, neither of which are included' do
        assert_size 2, Hashtag.excluded
        assert Hashtag.excluded.none?(&:include?)
      end
    end
    
    should 'properly format hashtags as a search query' do 
      assert_equal '#haiti OR #test -donate -support', Hashtag.search_string
    end
  end
    
end
