class CarModel < ApplicationRecord
  has_one :car
  validates :name, presence: true
end
