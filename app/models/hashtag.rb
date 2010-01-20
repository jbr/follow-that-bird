class Hashtag < ActiveRecord::Base
  validates_uniqueness_of :tag
  
  def with_hash
    "##{tag}"
  end
  
  def self.search_string
    all.map(&:with_hash).join(" OR ")
  end
end
