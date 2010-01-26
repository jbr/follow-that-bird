class CreateTaggings < ActiveRecord::Migration
  def self.up
    create_table :taggings do |t|
      t.integer :syntax_id
      t.integer :tweet_id
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :taggings
  end
end
