class ProjectAdminsJoinTable < ActiveRecord::Migration
  def change
    create_table :project_admins do |t|
      t.column :project_id, :integer
      t.column :user_id, :integer
      t.index [:project_id, :user_id]
      t.timestamps
    end
  end
end
