ActionController::Routing::Routes.draw do |map|
  map.resource :admin_session
  map.resources :tweets
  map.root :controller => "tweets"
end
