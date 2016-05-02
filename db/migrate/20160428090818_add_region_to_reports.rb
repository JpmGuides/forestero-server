class AddRegionToReports < ActiveRecord::Migration[5.0]
  def change
    add_column :reports, :region, :string
  end
end
