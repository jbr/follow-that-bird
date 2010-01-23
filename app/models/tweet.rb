class Tweet < ActiveRecord::Base
  validates_uniqueness_of :tweet_id
  
  def to_s
    "#{from_user}: #{text}"
  end
  
  def self.update_from_twitter
    count = 0
    Twitter::Search.new(Hashtag.search_string).since(Tweet.last.try(:tweet_id) || 0).each do |tweet|
      if tweet.geo.present? && tweet.geo.coordinates.present?
        latitude, longitude = *tweet.geo.coordinates
      else
        latitude, longitude = nil, nil
      end
      if Tweet.create(:tweet_id => tweet.id, 
                      :text => tweet.text, 
                      :from_user => tweet.from_user, 
                      :time_of_tweet => tweet.created_at, 
                      :to_user => tweet.to_user,
                      :profile_image_url => tweet.profile_image_url,
                      :source => tweet.source,
                      :latitude => latitude,
                      :longitude => longitude
                      ).valid?
        count += 1
      end
    end
    puts "added #{count} (total: #{Tweet.count})" if count > 0
  end
  
  
  def self.poll_indefinitely()
    polls_per_second = AppConfig.twitter_polls_per_hour / 60.0 / 60.0
    pause = 1.0 / polls_per_second
    loop do
      update_from_twitter
      sleep pause
    end
  end
  
  # Getter that converts from database-version of latitude (which is multiplied by 1,000,000)
  def latitude
    latitude_times_1000000.nil? ? nil : latitude_times_1000000 / 1_000_000.0
  end
  
  # Setter that converts to database-version of latitude (which is multiplied by 1,000,000)
  def latitude=(lat)
    self.latitude_times_1000000 = lat.nil? ? nil : lat * 1_000_000.0
  end
  
  # Getter that converts from database-version of longitude (which is multiplied by 1,000,000)
  def longitude
    longitude_times_1000000.nil? ? nil : longitude_times_1000000 / 1_000_000.0
  end
  
  # Setter that converts to database-version of longitude (which is multiplied by 1,000,000)
  def longitude=(long)
    self.longitude_times_1000000 = long.nil? ? nil : long * 1_000_000.0
  end
  
end
