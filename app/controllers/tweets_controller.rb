class TweetsController < InheritedResources::Base
  admin :required
  actions :all
  
  protected

  def collection
    @tweets ||= Tweet.need_triage.id_not_in(self.tweet_ids_voted_on)
  end
  
end