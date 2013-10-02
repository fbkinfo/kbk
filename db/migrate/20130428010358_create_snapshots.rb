class CreateSnapshots < ActiveRecord::Migration
  def change
    create_table :snapshots do |t|
      t.belongs_to    :document
      t.string        :original_scan
      t.string        :public_scan
      t.integer       :number
      t.timestamps
    end

    add_index :snapshots, [:document_id]
  end
end
