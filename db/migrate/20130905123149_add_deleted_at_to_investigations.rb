class AddDeletedAtToInvestigations < ActiveRecord::Migration
  def change
    add_column :investigations, :deleted_at, :datetime
  end
end
