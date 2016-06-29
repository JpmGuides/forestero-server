class AddSiteInfoToReports < ActiveRecord::Migration[5.0]
  def change
    add_column :reports, :site_active_gps, :string
    add_column :reports, :site_latitude, :string
    add_column :reports, :site_longitude, :string
    add_column :reports, :site_accuracy, :string
    add_column :reports, :site_age, :string
    add_column :reports, :device_id, :string
  end
end
