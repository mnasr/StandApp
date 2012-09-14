class RemoveTicketIdAndCategoryFromEntries < ActiveRecord::Migration
  def up
  	remove_column :entries, :ticket_id
  	remove_column :entries, :category
  end

  def down
  end
end
