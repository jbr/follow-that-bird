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
end
