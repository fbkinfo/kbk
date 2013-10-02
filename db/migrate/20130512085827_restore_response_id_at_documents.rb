class RestoreResponseIdAtDocuments < ActiveRecord::Migration
  def change
    change_table :documents do |t|
      t.integer   :response_id
      t.index     :response_id
    end
  end
end
