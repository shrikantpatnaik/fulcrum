class MakeFirstUserAdmin < ActiveRecord::Migration
  def self.up
    u = User.first
    if u
      u.roles = ["admin"]
      u.save
    end
  end

  def self.down
    u = User.first
    if u
      u.roles = []
      u.save
    end
  end
end
