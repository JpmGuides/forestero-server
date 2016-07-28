class ChangeReportDeviceIdToInteger < ActiveRecord::Migration[5.0]
  def change
    change_column :reports, :device_id, 'integer USING CAST(device_id AS integer)'
  end
end
