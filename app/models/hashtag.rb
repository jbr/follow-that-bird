class Hashtag < ActiveRecord::Base
  validates_uniqueness_of :tag
  
  def with_hash
    "##{tag}"
  end
  
  def with_exclusion
    "-#{tag}"
  end
  
  def self.search_string
    Hashtag.find_all_by_include(true).map(&:with_hash).join(" OR ") + " " +
    Hashtag.find_all_by_include(false).map(&:with_exclusion).join(" ")
  end
end
