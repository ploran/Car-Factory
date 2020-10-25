class Car < ApplicationRecord
  belongs_to :car_computer, optional: true
  belongs_to :car_model
  has_one :assembly

  validates :car_model, presence: true

  def completed?
    year? & wheels? & chasis? & laser? & car_computer.present? & engine? & seats?
  end

  def self.cars_by_model
    models = {}
    #Devuelve la cantidad de autos por modelo
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
      #Se considera que si esta en la Linea 1 no posee aun Computadora
      CarComputer.find_by_name(chasis).defects
    end
  end

end
