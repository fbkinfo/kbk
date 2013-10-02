class AddPdfToDocuments < ActiveRecord::Migration
  def change
    change_table :documents do |t|
      t.string :pdf
    end
  end
end
