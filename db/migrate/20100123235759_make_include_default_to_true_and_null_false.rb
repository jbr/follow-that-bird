class MakeIncludeDefaultToTrueAndNullFalse < ActiveRecord::Migration
  def self.up
    execute "update hashtags set include = 'false' where include is null"
    change_column :hashtags, :include, :boolean, :default => true, :null => false
  end

  def self.down
    change_column :hashtags, :include, :boolean, :null => true
  end
end
