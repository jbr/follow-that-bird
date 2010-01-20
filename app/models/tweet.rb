class Tweet < ActiveRecord::Base
  validates_uniqueness_of :tweet_id
  
  def self.update_from_twitter
    count = 0
    Twitter::Search.new(Hashtag.search_string).since(Tweet.last.try(:tweet_id) || 0).each do |tweet|
      if Tweet.create(:tweet_id => tweet.id, :text => tweet.text, :from_user => tweet.from_user).valid?
        count += 1
      end
    end
    puts "added #{count} (total: #{Tweet.count})"
  end
  
  
  def self.poll_indefinitely(pause = 2)
    update_from_twitter
    sleep pause
    poll_indefinitely
  end
end
