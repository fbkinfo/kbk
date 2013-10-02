class AddWAndHToSnapshots < ActiveRecord::Migration
  def change
    change_table :snapshots do |t|
      t.integer   :original_scan_width
      t.integer   :original_scan_height
      t.integer   :public_scan_width
      t.integer   :public_scan_height
    end
  end
end
