class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string     :title
      t.text       :description
      t.string     :kind
      t.date       :document_date
      t.date       :due_date
      t.belongs_to :organization
      t.belongs_to :investigation
      t.belongs_to :user
      t.belongs_to :response

      t.timestamps
    end

    add_index :documents, [:kind, :document_date]
    add_index :documents, [:kind, :due_date]
    add_index :documents, :user_id
    add_index :documents, :investigation_id
    add_index :documents, :organization_id
    add_index :documents, :response_id
  end
end
