class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.string :text, :null => false
      t.string :from_user, :null => false
      t.integer :tweet_id
      t.datetime :time_of_tweet
      t.string :to_user      
      t.string :source
      t.string :profile_image_url
      t.integer :longitude_times_1000000
      t.integer :latitude_times_1000000
      t.timestamps
    end
  end

  def self.down
    drop_table :tweets
  end
end
