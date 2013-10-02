class AddDocumentsFinalIndex < ActiveRecord::Migration
  def change
    add_index :documents, :final
  end
end
