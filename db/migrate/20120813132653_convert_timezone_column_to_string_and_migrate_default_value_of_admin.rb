class ConvertTimezoneColumnToStringAndMigrateDefaultValueOfAdmin < ActiveRecord::Migration
  def up
  	remove_column :users, :timezone
  	change_column :users, :admin, :boolean, :default => false

  	add_column :users, :timezone, :string
  end

  def down
  	remove_column :users, :timezone
  	change_column :users, :admin, :boolean, :default => true

  	add_column :users, :timezone, :integer
  end
end
