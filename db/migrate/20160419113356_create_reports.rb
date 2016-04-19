class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.datetime :taken_at
      t.string :site_reference
      t.string :site_id
      t.string :visit_id
      t.integer :humiditiy
      t.integer :canopy
      t.integer :flowers
      t.integer :bp
      t.boolean :harvesting
      t.boolean :drying
      t.boolean :fertilizer
      t.boolean :wilt

      t.timestamps
    end
  end
end
