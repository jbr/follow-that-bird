class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.string :text
      t.string :from_user
      t.integer :tweet_id
      t.string :geo
      t.integer :from_user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tweets
  end
end
