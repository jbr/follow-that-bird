class Hashtag < ActiveRecord::Base
  validates_uniqueness_of :tag
  
  named_scope :included, :conditions => {:include => true}
  named_scope :excluded, :conditions => {:include => false}
  
  def with_hash
    "##{tag}"
  end
  
  def with_exclusion
    "-#{tag}"
  end
  
  def self.search_string
    Hashtag.included.map(&:with_hash).join(" OR ") + " " +
    Hashtag.excluded.map(&:with_exclusion).join(" ")
  end
end
