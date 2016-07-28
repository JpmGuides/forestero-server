class CreateDevices < ActiveRecord::Migration[5.0]
  def change
    create_table :devices do |t|
      t.string :uuid
      t.string :name

      t.timestamps
    end
  end
end
