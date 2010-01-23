ActionController::Routing::Routes.draw do |map|
  map.resource :admin_session
  map.resources :tweets

  map.vote "/tweets/:id/:vote", :controller => "tweet_votes", :action => "vote", :method => "post"
  map.root :controller => "tweets"
end
