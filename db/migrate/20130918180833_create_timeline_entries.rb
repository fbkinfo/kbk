class CreateTimelineEntries < ActiveRecord::Migration
  def change
    create_table :timeline_entries do |t|
      t.string :resource_type, null: false
      t.integer :resource_id, null: false
      t.references :investigation, null: false
      t.date :entry_date, null: false

      t.timestamps
    end
    add_index :timeline_entries, :investigation_id

    add_index :timeline_entries, [:resource_type, :resource_id], unique: true
  end
end
