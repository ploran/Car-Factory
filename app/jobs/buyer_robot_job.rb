class BuyerRobotJob < ApplicationJob
  queue_as :default

  def perform(*args)
    logger.info "BuyerRobot generando compra"
    ids = CarFactory.car_models.ids
    buy_cars(rand(1..10),rand(ids.count))
    self.class.set(wait: 20.minutes).perform_later()
    logger.info "BuyerRobot finalizando compra"

  end

  def buy_cars(quantity, car_model_id)
    CarFactory.sale_cars(quantity, car_model_id)
  end
end
