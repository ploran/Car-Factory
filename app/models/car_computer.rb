class CarComputer < ApplicationRecord
  has_one :car
  has_many :defects

  validates :name, presence: true
  validates :name, uniqueness: true

  def has_defects?
    defects.empty? == false
  end


end
