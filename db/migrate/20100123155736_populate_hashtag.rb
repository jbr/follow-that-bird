class PopulateHashtag < ActiveRecord::Migration
  def self.up
    Hashtag.create(:tag => "haiti")
  end

  def self.down
    Hashtag.find_by_tag("haiti").destroy()
  end
end
