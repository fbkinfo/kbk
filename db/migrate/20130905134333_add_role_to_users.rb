class AddRoleToUsers < ActiveRecord::Migration
  def up
    add_column :users, :role, :string
    execute "update users set role='lawyer';"
    change_column :users, :role, :string, null: false
  end

  def down
    remove_column :users, :role
  end
end
