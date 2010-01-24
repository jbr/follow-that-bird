class MakeIncludeDefaultToTrueAndNullFalse < ActiveRecord::Migration
  def self.up
    change_column :hashtags, :include, :boolean, :default => true, :null => false
  end

  def self.down
    change_column :hashtags, :include, :boolean, :null => true
  end
end
