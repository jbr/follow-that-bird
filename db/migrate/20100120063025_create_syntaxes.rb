class CreateSyntaxes < ActiveRecord::Migration
  def self.up
    create_table :syntaxes do |t|
      t.string :format

      t.timestamps
    end
  end

  def self.down
    drop_table :syntaxes
  end
end
