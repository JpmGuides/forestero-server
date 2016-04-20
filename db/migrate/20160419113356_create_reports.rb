class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.datetime :taken_at
      t.string :site_reference
      t.string :site_id
      t.string :visit_id
      t.integer :humidity
      t.integer :canopy
      t.integer :leaf
      t.integer :maintenance
      t.integer :flowers
      t.boolean :bp
      t.boolean :harvesting
      t.boolean :drying
      t.boolean :fertilizer
      t.boolean :wilt

      t.timestamps
    end
  end
end
