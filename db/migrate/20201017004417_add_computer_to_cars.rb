class AddComputerToCars < ActiveRecord::Migration[5.1]
  def change
    add_reference :cars, :car_computer, index: true
    add_foreign_key :cars, :car_computers
  end
end
