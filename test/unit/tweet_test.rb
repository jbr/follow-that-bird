require 'test_helper'

class TweetTest < ActiveSupport::TestCase
  context 'with one saved tweet' do
    setup {@tweet = Tweet.create! :text => "hello world", :from_user => "rhok", :tweet_id => 1,
                                  :to_user => 'johnq', :source => 'Umlaüt.app',
                                  :profile_image_url => 'http://images.somewhere.com/1294u243121.jpg',
                                  :time_of_tweet => 'Sat, 23 Jan 2010 14:12:09 +0100' }
    
    should 'know its from_user' do
      assert_equal 'rhok', @tweet.from_user
    end
    
    should 'know its to_user' do
      assert_equal 'johnq', @tweet.to_user
    end
    
    should 'know its profile image URL' do
      assert @tweet.profile_image_url =~ /images\.somewhere/
    end
    
    should 'know the time of the tweet' do
      assert @tweet.time_of_tweet > Time.parse('Sat, 23 Jan 2010 00:00:00 +0000')
      assert @tweet.time_of_tweet < Time.parse('Sun, 24 Jan 2010 00:00:00 +0000')
    end
    
    context 'to_s' do
      should 'be the from user and the tweet' do
        assert_to_s "rhok: hello world", @tweet
      end
    end
    
    context 'another tweet with the same tweet_id' do
      setup {@dupe = Tweet.new :text => "maybe different", :from_user => "maybe different", :tweet_id => 1}
      
      should 'not be valid' do
        assert_not_valid @dupe
        assert_equal "has already been taken", @dupe.errors.on(:tweet_id)
      end
    end
  end
  
  context 'a Tweet with no lat/long' do
    setup {@tweet = Tweet.create! :text => "hello world", :from_user => "rhok", :tweet_id => 1}
    
    should 'have a nil latitude' do
      assert_nil @tweet.latitude
    end
    should 'have a nil latitude stored to the database' do
      assert_nil @tweet.latitude_times_1000000
    end
    should 'have a nil longitude' do
      assert_nil @tweet.longitude
    end
    should 'have a nil longitude stored to the database' do
      assert_nil @tweet.longitude_times_1000000
    end
  end
  
  context 'a Tweet with a Lat/Long' do
    setup { @tweet = Tweet.create!(:latitude => -45.0, :longitude => 17.2, :text => "hello world", :from_user => "rhok", :tweet_id => 2)}
    should 'expose its latitude as an actual latitude' do
      assert_equal -45.0, @tweet.latitude
    end
    should 'expose its longitude as an actual longitude' do
      assert_equal 17.2, @tweet.longitude
    end
    should 'save latitude as *1,000,000' do
      assert_equal -45_000_000, @tweet.latitude_times_1000000
    end
    should 'save longitude as *1,000,000' do
      assert_equal 17_200_000, @tweet.longitude_times_1000000
    end
    should 'properly set the underlying latitude when changing the exposed latitude' do
      @tweet.latitude = 11.987
      assert_equal 11_987_000, @tweet.latitude_times_1000000
    end
    should 'properly set the underlying longitude when changing the exposed longitude' do
      @tweet.longitude = -12.54
      assert_equal -12_540_000, @tweet.longitude_times_1000000
    end
  end
  
end
