class CreateTrees < ActiveRecord::Migration[5.0]
  def change
    create_table :trees do |t|
      t.integer :tiny
      t.integer :small
      t.integer :large
      t.integer :mature
      t.integer :rife
      t.integer :damaged
      t.integer :blackpod
      t.integer :report_id

      t.timestamps
    end

    add_index :trees, :report_id
  end
end
