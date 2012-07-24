class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.text :description
      t.string :category
      t.integer :user_id
      t.integer :ticket_id

      t.timestamps
    end
  end
end
