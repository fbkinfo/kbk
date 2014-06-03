class AddIndexes < ActiveRecord::Migration
  def change
    add_index :authors, :user_id
    add_index :documents, :author_id
    add_index :favourites, :user_id
    add_index :favourites, [:entry_id, :entry_type]
    add_index :investigations, :latest_document_id
    add_index :investigations, :user_id
  end
end
