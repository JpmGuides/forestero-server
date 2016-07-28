class AddDemoToReports < ActiveRecord::Migration[5.0]
  def change
    add_column :reports, :demo, :boolean
  end
end
