class BuyerRobotJob < ApplicationJob
  queue_as :default

  def perform(*args)
    logger.info "BuyerRobot generating purchase"
    ids = CarFactory.car_models.ids
    buy_cars(rand(1..10),ids.shuffle.first)
    self.class.set(wait: 35.minutes).perform_later()
    logger.info "BuyerRobot finalishing purchase"
    #The Other problem
    logger.info "======================================="
    logger.info "Buyer Robot have Sale Order request for model #{ids.shuffle.first}"
    CarFactory.change_car_model(order_for_change(), ids.shuffle.first)
  end

  def buy_cars(quantity, car_model_id)
    CarFactory.sale_cars(quantity, car_model_id)
  end

  def order_for_change()
    order_ids = SaleOrder.all.collect { |order| order.id}
    return order_ids.shuffle.first
  end
end
