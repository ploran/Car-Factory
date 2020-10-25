class CreateSaleOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :sale_orders do |t|
      t.references :car, foreign_key: true

      t.timestamps
    end
  end
end
