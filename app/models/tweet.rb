class Tweet < ActiveRecord::Base
  cattr_accessor :twitter
  validates_uniqueness_of :tweet_id
  
  def self.connect
    auth = Twitter::HTTPAuth.new(AppConfig.twitter_username, AppConfig.twitter_password)
    @@twitter = Twitter::Base.new auth
  end
  
  def self.update_from_twitter
    Twitter::Search.new(Hashtag.search_string).each do |tweet|
      Tweet.create :tweet_id => tweet.id, :text => tweet.text, :from_user => tweet.from_user
    end
  end
end
