require 'httparty'
class Push
  def self.push_indefinitely()
    polls_per_second = AppConfig.twitter_polls_per_hour / 60.0 / 60.0
    desired_pause = 1.0 / polls_per_second
    loop do
      time_at_start = Time.now
      push_once
      poll_duration = Time.now - time_at_start
      if desired_pause - poll_duration > 0 
        actual_pause = desired_pause - poll_duration
      else
        actual_pause = 0
      end
      sleep actual_pause 
    end
  end
  
  def self.push_once
    puts "sending xml message"
    HTTParty.post("http://localhost:3000", :body => Tweet.pull_next)
  end
end