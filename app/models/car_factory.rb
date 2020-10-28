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
    GuardRobotJob.set(wait: 30.minutes).perform_later()
    BuyerRobotJob.set(wait: 35.minutes).perform_later()
    logger.info "==========================="
    logger.info "Robots prepared: BuilderRobot, GuardRobot and BuyerRobot"
  end

  def self.sale_cars(quantity, car_model_id)
    car_ids = Assembly.sale_cars("Store", car_model_id, quantity)
    if car_ids.size < quantity
      #Inform that the total order cannot be fulfilled
      # of vehicles, available ones will be sold
      logger.warn "The BuyerRobot requests #{quantity} but only #{car_ids.size} is available"
      logger.info "Cars will be requested from Warehouse"
      car_ids = Assembly.sale_cars("Warehouse", car_model_id, quantity)
      Car.find(car_ids).each { |car| car.prepare_car }
      times = car_ids.size
    end
      CarFactory.generate_order(car_ids)
  end

  def self.generate_order(car_ids)
    cars = Car.find(car_ids)
    cars.each{ |car|
      SaleOrder.create(car: car)
      car.assembly.status = 1 #1 car sale in Store
      car.assembly.save
      logger.info "Sales order generated for the car #{car.id}"
    }
  end

  def self.daily_resume
    daily_income = SaleOrder.daily_income
    cars_sold = SaleOrder.cars_sold
    puts "Daily Resume:"
    puts "-----------------------------"
    puts "Daily Income: $#{daily_income.to_s("F")}"
    puts "-----------------------------"
    puts "Cars Sold: #{cars_sold}"
    puts "-----------------------------"
    puts "Average Order Value: $#{(daily_income / cars_sold).to_s("F")}"
  end

end
