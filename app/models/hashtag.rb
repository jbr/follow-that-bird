class Hashtag < ActiveRecord::Base
  validates_uniqueness_of :tag
end
