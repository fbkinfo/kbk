class MakeDocumentAttachementDocumentIdNull < ActiveRecord::Migration
  def up
    change_column :document_attachements, :document_id, :integer, null: true
  end

  def down
    change_column :document_attachements, :document_id, :integer, null: false
  end
end
