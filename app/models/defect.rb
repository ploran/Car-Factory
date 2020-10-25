class Defect < ApplicationRecord
  belongs_to :car_computer

  validates :description, presence: true
end
