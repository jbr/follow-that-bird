class TweetsController < InheritedResources::Base
  admin :required
  actions :all
  
  protected

  def collection
    @tweets ||= Tweet.need_triage
  end
  
end