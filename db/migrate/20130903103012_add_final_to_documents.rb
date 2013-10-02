class AddFinalToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :final, :boolean, default: false, null: false
  end
end
