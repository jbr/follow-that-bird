require 'nokogiri'
class PushMessage
  attr_accessor :tweet_collection
  def initialize(tweet_collection)
    @tweet_collection = tweet_collection
  end
  
  def to_xml
    xml = Nokogiri::XML::Document.new()
    xml << tweets = Nokogiri::XML::Node.new("tweets",xml)
    tweet_collection.each do |t|
      tweets << tweet = Nokogiri::XML::Node.new("tweet",xml)
      %w(
        from_user tweet_id time_of_tweet to_user
        source profile_image_url longitude_times_1000000
        latitude_times_1000000
      ).each { |cc| tweet.set_attribute(cc, t.send(cc).to_s) }
      tweet.content = t.text
    end
    xml.to_s
  end
end