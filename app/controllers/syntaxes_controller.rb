class TweetsController < InheritedResources::Base
  admin :required
  actions :all
end