class ChangePricesToCar < ActiveRecord::Migration[5.1]
  def change
    change_column :cars, :cost_price, :decimal, precision: 8, scale: 2
    change_column :cars, :price, :decimal, precision: 8, scale: 2
  end
end
