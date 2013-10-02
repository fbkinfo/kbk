class MakeInvestigationProjectKindNotNull < ActiveRecord::Migration
  def up
    execute "update investigations set project_kind='investigation';"
    change_column :investigations, :project_kind, :string, null: false
  end

  def down
    change_column :investigations, :project_kind, :string
  end
end
