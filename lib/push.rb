require 'httparty'
class Push
  def self.push_indefinitely()
    polls_per_second = AppConfig.twitter_polls_per_hour / 60.0 / 60.0
    desired_pause = 1.0 / polls_per_second
    
    in_intervals_of desired_pause do
      push_once
    end
  end
  
  def self.push_once
    puts "sending xml message"
    HTTParty.post "http://localhost:3000", :body => Tweet.pull_next
  end
  
  def self.in_intervals_of(seconds, &blk)
    loop do
      time_at_start = Time.now
      blk.call
      poll_duration = Time.now - time_at_start
      sleep [seconds - poll_duration, 0].max
    end
  end
end