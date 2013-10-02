class CreateFavourites < ActiveRecord::Migration
  def change
    create_table :favourites do |t|
      t.belongs_to    :user
      t.references    :entry, polymorphic: true
      t.timestamps
    end
  end
end
