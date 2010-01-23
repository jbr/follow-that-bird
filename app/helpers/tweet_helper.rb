module TweetHelper
  def link_to_twitter_user(username)
    link_to username, "http://twitter.com/#{username}"
  end
end