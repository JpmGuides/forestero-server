class CreateDayTexts < ActiveRecord::Migration[5.0]
  def change
    create_table :day_texts do |t|
      t.text :text
      t.date :date

      t.timestamps
    end
  end
end
