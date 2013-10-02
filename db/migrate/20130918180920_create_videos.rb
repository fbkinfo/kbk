class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.text :body, null: false
      t.references :investigation, null: false
      t.date :entry_date, null: false

      t.timestamps
    end

    add_index :videos, :investigation_id
  end
end
