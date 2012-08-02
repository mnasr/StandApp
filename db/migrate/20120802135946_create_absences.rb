class CreateAbsences < ActiveRecord::Migration
  def change
    create_table :absences do |t|
      t.integer :user_id
      t.text :description

      t.timestamps
    end
  end
end
