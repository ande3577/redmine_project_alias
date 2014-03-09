class AddDefaultAliasToProject < ActiveRecord::Migration
  def change
    add_column :projects, :default_alias_id, :integer
  end
end
