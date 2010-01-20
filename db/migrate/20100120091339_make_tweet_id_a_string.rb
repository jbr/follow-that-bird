class MakeTweetIdAString < ActiveRecord::Migration
  def self.up
    rename_column :tweets, :tweet_id, :tweet_id_old
    add_column :tweets, :tweet_id, :string
    execute "update tweets set tweet_id = tweet_id_old"
    remove_column :tweets, :tweet_id_old
  end

  def self.down
    rename_column :tweets, :tweet_id, :tweet_id_old
    add_column :tweets, :tweet_id, :integer
    execute "update tweets set tweet_id = tweet_id_old"
    remove_column :tweets, :tweet_id_old
  end
end
