class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :image, null: false
      t.text :comment
      t.references :investigation, null: false
      t.date :entry_date, null: false

      t.timestamps
    end

    add_index :photos, :investigation_id
  end
end
