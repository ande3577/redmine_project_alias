class CreateProjectAliases < ActiveRecord::Migration
  def change
    create_table :project_aliases do |t|
      t.integer :project_id
      t.string :alias, :limit => 20
    end
  end
end
