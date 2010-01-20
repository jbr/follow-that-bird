require 'test_helper'

class TweetTest < ActiveSupport::TestCase
  context 'with one saved tweet' do
    setup {@tweet = Tweet.create! :text => "hello world", :from_user => "rhok", :tweet_id => 1}
    
    context 'another tweet with the same tweet_id' do
      setup {@dupe = Tweet.new :text => "maybe different", :from_user => "maybe different", :tweet_id => 1}
      
      should 'not be valid' do
        assert_not_valid @dupe
        assert_equal "has already been taken", @dupe.errors.on(:tweet_id)
      end
    end
  end
end
