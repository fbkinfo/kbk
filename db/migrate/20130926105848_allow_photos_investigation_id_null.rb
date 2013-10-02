class AllowPhotosInvestigationIdNull < ActiveRecord::Migration
  def up
    change_column :photos, :investigation_id, :integer, null: true
    change_column :photos, :entry_date, :date, null: true
  end

  def down
    change_column :photos, :investigation_id, :integer, null: false
    change_column :photos, :entry_date, :date, null: false
  end
end
