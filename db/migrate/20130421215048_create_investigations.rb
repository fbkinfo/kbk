class CreateInvestigations < ActiveRecord::Migration
  def change
    create_table :investigations do |t|
      t.string      :title, :null => false, :default => nil
      t.text        :description
      t.string      :status, :null => false, :default => nil
      t.belongs_to  :latest_document
      t.belongs_to  :user
      t.date        :closed_at

      t.timestamps
    end

    add_index :investigations, :title, :unique => true
  end
end
