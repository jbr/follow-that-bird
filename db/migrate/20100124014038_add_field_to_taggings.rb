class AddFieldToTaggings < ActiveRecord::Migration
  def self.up
    add_column :taggings, :field, :string
  end

  def self.down
    remove_column :taggings, :field
  end
end
