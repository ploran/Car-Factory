class CreateDefects < ActiveRecord::Migration[5.1]
  def change
    create_table :defects do |t|
      t.references :car_computer, foreign_key: true
      t.string :description, null: false

      t.timestamps
    end
  end
end
