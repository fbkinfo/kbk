class AddDeletedAtToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :deleted_at, :datetime
  end
end
