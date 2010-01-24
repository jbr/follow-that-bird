class Tweet < ActiveRecord::Base
  validates_uniqueness_of :tweet_id
  
  has_many :taggings, :dependent => :destroy

  def to_s
    "#{from_user}: #{text}"
  end
  
  def self.update_from_twitter
    count = 0
    Twitter::Search.new(Hashtag.search_string).since(Tweet.last.try(:tweet_id) || 0).per_page(100).each do |tweet|
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
    if count >= 100
      puts "WARNING: You probably missed tweets with this poll. If possible, speed up your poll rate"
    end
  end
  
  
  def self.poll_indefinitely()
    polls_per_second = AppConfig.twitter_polls_per_hour / 60.0 / 60.0
    desired_pause = 1.0 / polls_per_second
    loop do
      time_at_start = Time.now
      update_from_twitter
      poll_duration = Time.now - time_at_start
      if desired_pause - poll_duration > 0 
        actual_pause = desired_pause - poll_duration
      else
        actual_pause = 0
      end
      sleep actual_pause 
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
