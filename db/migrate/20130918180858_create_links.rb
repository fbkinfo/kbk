class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :title, null: false
      t.text :comment
      t.string :url, null: false
      t.string :icon
      t.references :investigation, null: false
      t.date :entry_date, null: false

      t.timestamps
    end

    add_index :links, :investigation_id
  end
end
