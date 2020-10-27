class Assembly < ApplicationRecord
  belongs_to :car
  has_one :car_model, through: :car
  delegate  :chasis, :wheels, :engine, :seats, :car_computer, :laser,
            :cost_price, :price, :year,
            to: :car, prefix: true, allow_nil: true

  LINE_OPTIONS = ['Basic Structure',
                  'Electronic devices',
                  'Paint & Final Details',
                  'Warehouse',
                  'Store']
  validates :line, presence: true, inclusion: LINE_OPTIONS
  validates :status, presence: true, inclusion: { in: 0..1 }#0 Pending #1 Finalized

  def self.input_new_car(car)
    car.save
    car.create_assembly(line: LINE_OPTIONS[0], status: 0)
    puts "Car input to Basic Structure"
    car.save!
  end

  def self.lines(line_name, status)
    self.includes(:car).where(line: line_name, status: status)
  end

  def prepare_car(chasis, wheels, engine, seats)
    car.chasis = chasis
    car.wheels = wheels
    car.engine = engine
    car.seats  = seats
    car.save
  end

  def assign_electronic(car_computer, laser)
    car.car_computer = car_computer
    car.laser = laser
    car.save
  end

  def assign_car_prices(cost_price, price, year)
    car.cost_price = cost_price
    car.price = price
    car.year = year
    car.save
  end

  def self.sale_cars(line_name, car_model_id, quantity)
    lines = Assembly.joins(:car_model).where(line: line_name, status: 0)
    lines_for_model = lines.limit(quantity).select {|line|
                                              line.car.car_model_id = car_model_id}
    return lines_for_model.collect { |line| line.car_id}
  end

  def self.stock_by_model(line_name,status)
    cars_by_model_id = Assembly.joins(:car_model).where(line: line_name,status: status).group(:car_model_id).count
    car_models = CarModel.all
    models= {}
    cars_by_model_id.each {|model_id, quantity|
      models[car_models[model_id].name] = quantity
    }
    return models
  end

  def self.line(index)
    LINE_OPTIONS[index]
  end

end
