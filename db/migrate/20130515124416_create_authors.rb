class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string      :name
      t.belongs_to  :user
      t.timestamps
    end

    change_table :documents do |t|
      t.belongs_to  :author
    end
  end
end
