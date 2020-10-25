class CarFactory < ActiveRecord::Base
  self.abstract_class = true

  def self.car_models
    CarModel.all
  end

  def self.car_model(id)
    self.car_models.find(id)
  end

  def self.build_car
    return Car.new()
  end

  def self.completed_cars
    Car.includes(:car_computer).select {|car|
      car.completed?
    }
  end

  def self.start_robots
    BuilderRobotJob.set(wait: 1.minutes).perform_now()
    GuardRobotJob.set(wait: 15.minutes).perform_later()
    BuyerRobotJob.set(wait: 20.minutes).perform_later()
    logger.info "==========================="
    logger.info "Robots preparados: BuilderRobot, GuardRobot y BuyerRobot"
  end

  def self.sale_cars(quantity, car_model_id)
    cars = Assembly.sale_cars("Store", car_model_id, quantity)
    if cars.size >= quantity
      times = quantity
    else
      #Informar que no se puede cumplir con el pedido total
      #de vehiculos, se venderan los disponibles
      logger.warn "El BuyerRobot solicita #{quantity} pero solo hay #{cars.size} disponible"
      times = cars.size
    end
    times.times do |i|
      CarFactory.generate_order(cars[i])
    end
  end

  def self.generate_order(car_id)
    car = Car.find(car_id)
    SaleOrder.create(car_id: car_id)
    car.assembly.status = 1 #1 significa vendido en Store
    car.assembly.save
    logger.info "Pedido de Orden generada para el auto #{car_id}"
  end

end
