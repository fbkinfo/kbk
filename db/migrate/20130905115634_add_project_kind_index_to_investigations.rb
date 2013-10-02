class AddProjectKindIndexToInvestigations < ActiveRecord::Migration
  def change
    add_index :investigations, :project_kind
  end
end
