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
    GuardRobotJob.set(wait: 5.minutes).perform_later()
    BuyerRobotJob.set(wait: 6.minutes).perform_later()
    logger.info "==========================="
    logger.info "Robots prepared: BuilderRobot, GuardRobot and BuyerRobot"
  end

  def self.sale_cars(quantity, car_model_id,order_id=nil)
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
      if car_ids.any? & order_id.present?
        CarFactory.generate_order(car_ids)
      elsif order_id.present?
        puts "Autos encontrados para ese modelo: #{car_ids}"
        CarFactory.update_order(order_id, car_ids.first)
      end
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

  def self.change_car_model(order_id, car_model_id)
    self.sale_cars(1, car_model_id,order_id)
  end

  def self.update_order(order_id, car_id)
    car = Car.find_by_id(car_id)
    order = SaleOrder.find_by_id(order_id)
    unless car.nil? & order.nil?
      order.car = car
      order.save
      logger.info "Sales order N° #{order_id} change for the car #{car_id}"
    end
  end

end
