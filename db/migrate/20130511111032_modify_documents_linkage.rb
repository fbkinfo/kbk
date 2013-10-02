class ModifyDocumentsLinkage < ActiveRecord::Migration
  def change
    change_table :documents do |t|
      t.remove    :response_id
      t.string    :ancestry
      t.index     :ancestry
    end
  end
end
