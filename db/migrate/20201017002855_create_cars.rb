class CreateCars < ActiveRecord::Migration[5.1]
  def change
    create_table :cars do |t|
      t.references :car_model
      t.integer :year
      t.integer :wheels
      t.string :chasis
      t.string :laser
      t.string :engine
      t.decimal :price
      t.decimal :cost_price
      t.integer :seats

      t.timestamps
    end
  end
end
