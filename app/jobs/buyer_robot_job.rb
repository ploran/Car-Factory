class BuyerRobotJob < ApplicationJob
  queue_as :default

  def perform(*args)
    logger.info "BuyerRobot generating purchase"
    ids = CarFactory.car_models.ids
    buy_cars(rand(1..10),rand(ids.count))
    self.class.set(wait: 35.minutes).perform_later()
    logger.info "BuyerRobot finalishing purchase"

  end

  def buy_cars(quantity, car_model_id)
    CarFactory.sale_cars(quantity, car_model_id)
  end
end
