class AddingColumnsTimezoneAndWeekpatternToUsersTable < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.integer :timezone
      t.string :week_pattern

    
   end 
  end
  def self.down
  end 
end
