class AddProjectKindToInvestigations < ActiveRecord::Migration
  def change
    add_column :investigations, :project_kind, :string
  end
end
