class Tweet < ActiveRecord::Base
  validates_uniqueness_of :tweet_id
  
  # This is the method that the core view will use to 
  # show tweets that still need triaging.
  #
  # We will need to tweak the variables here for best
  # user experience.
  def self.need_triage
    self.recent(24.hours.ago).
         upvoted_less_than(5).
         downvoted_less_than(5).
         random.
         limit(15)
  end
  
  named_scope :recent, lambda { |*since|
    since = since.any? ? since.first : 2.days.ago
    { :conditions => ["#{self.table_name}.created_at > ?", since]}
  }
  
  named_scope :upvoted_less_than, lambda { |count| 
    { :conditions => ["#{self.table_name}.upvote_count < ?", count]}
  }
  
  named_scope :downvoted_less_than, lambda { |count| 
    { :conditions => ["#{self.table_name}.downvote_count < ?", count] }
  }
  
  named_scope :id_not_in, lambda { |ids|
    { :conditions => ["#{self.table_name}.id not in (?)", ids] }
  }
  
  named_scope :random, { :order => (AppConfig.database_random_method || 'random()') }
  
  named_scope :limit, lambda { |limit| { :limit => limit } }
  
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

  def add_upvote
    self.upvote_count += 1
  end

  def add_downvote
    self.downvote_count += 1
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
  

  def self.stream_from_twitter
    twitter_username = AppConfig.twitter_username
    twitter_password = AppConfig.twitter_password
    
    TweetStream::Client.new(twitter_username,twitter_password).track(Hashtag.search_string, :delete => Proc.new{ |status_id, user_id|}, :limit => Proc.new{ |skip_count| }) do |tweet|  
      if tweet.geo.present? && tweet.geo.coordinates.present?
        latitude, longitude = *tweet.geo.coordinates
      else
      latitude, longitude = nil, nil
      end
      if Tweet.create(:tweet_id => tweet[:id], 
                :text => tweet.text, 
                :from_user => tweet.user.screen_name, 
                :time_of_tweet => tweet.created_at, 
                :to_user => tweet.in_reply_to_screen_name,
                :profile_image_url => tweet.user.profile_image_url,
                :source => tweet.source,
                :latitude => latitude,
                :longitude => longitude
                ).valid?
        p tweet.text
      end
      
    end
  end
  
  def to_s
    "#{from_user}: #{text}"
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
