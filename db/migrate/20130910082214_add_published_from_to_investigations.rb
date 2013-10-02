class AddPublishedFromToInvestigations < ActiveRecord::Migration
  def change
    add_column :investigations, :published_until, :date
  end
end
