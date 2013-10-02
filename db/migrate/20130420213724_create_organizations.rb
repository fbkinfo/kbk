class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string  :name
      t.integer :documents_count, :default => 0
      t.integer :investigations_count, :default => 0

      t.timestamps
    end

    add_index :organizations, :name, :unique => true
  end
end
