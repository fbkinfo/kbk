class AddNameToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :name
    end

    add_index :users, :name, :unique => true
  end
end
