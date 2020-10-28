class SaleOrder < ApplicationRecord
  belongs_to :car
  validates :car, presence: true
  delegate :price, :cost_price, to: :car, prefix: true, allow_nil: true

  def self.daily_income
    car_prices = self.includes(:car).where(created_at: Date.today.all_day).collect {|order|
                  order.car_price}
    puts "Daily Income ..............$#{car_prices.sum.to_s("F")}"
  end

  def self.cars_sold
    cars_sold = self.includes(:car).where(created_at: Date.today.all_day).count
    puts "Cars Sold: #{cars_sold.size}"
  end
end
