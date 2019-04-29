class AddInfestAndForceRToTrees < ActiveRecord::Migration[5.0]
  def change
    add_column :trees, :small2, :integer
    add_column :trees, :infest, :integer
    add_column :trees, :force_r, :integer
  end
end
