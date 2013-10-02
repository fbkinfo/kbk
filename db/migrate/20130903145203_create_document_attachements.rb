class CreateDocumentAttachements < ActiveRecord::Migration
  def change
    create_table :document_attachements do |t|
      t.string :file, null: false
      t.references :document, null: false

      t.timestamps
    end
    add_index :document_attachements, :document_id
  end
end
