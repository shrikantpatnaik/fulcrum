class AddAPITokenToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :api_token, :string
  end
end
