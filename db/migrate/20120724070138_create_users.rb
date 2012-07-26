class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :fullname
      t.boolean :admin

      t.timestamps
    end
  end
end
