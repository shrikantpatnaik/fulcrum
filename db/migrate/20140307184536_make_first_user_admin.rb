class MakeFirstUserAdmin < ActiveRecord::Migration
  def self.up
    u = User.first
    u.roles = ["admin"]
    u.save
  end

  def self.down
    u = User.first
    u.roles = []
    u.save
  end
end
