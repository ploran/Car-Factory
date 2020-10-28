class Car < ApplicationRecord
  belongs_to :car_computer, optional: true
  belongs_to :car_model
  has_one :assembly
  delegate  :defects, to: :car_computer, prefix: true, allow_nil: true

  validates :car_model, presence: true

  def completed?
    year? & wheels? & chasis? & laser? & car_computer.present? & engine? & seats?
  end

  def self.cars_by_model
    models = {}
    #Returns the number of cars per model
    Car.group(:car_model).count.each do |model, quantity|
         models[model.name] = quantity
    end
    return models
  end

  def has_defects?
    if defects.present?
      car_computer.has_defects?
    else
      CarComputer.find_by_name(chasis).has_defects?
    end
  end

  def defects
    if car_computer.present?
      car_computer.defects
    else
      #It is considered that if the car on Line 1
      #you do not have yet a Computer
      CarComputer.find_by_name(chasis).defects
    end
  end

  def prepare_car
    logger.info "It is checked that the Car N°#{id} has no defects to be sold"
    defects.each { |defect|
      defect.destroy
      logger.info "The defect is repaired => #{defect.description}"
    }
  end
end
