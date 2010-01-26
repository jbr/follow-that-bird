class TweetVotesController < ApplicationController
  def vote
    @tweet = Tweet.find(params[:id])

    case params[:vote]
    when "up"
      @tweet.add_upvote
    when "down"
      @tweet.add_downvote
    end
    
    @tweet.save
    self.tweet_ids_voted_on << @tweet.id
    head :ok
  end
end
