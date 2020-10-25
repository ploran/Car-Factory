class SaleOrder < ApplicationRecord
  belongs_to :car

  validates :car, presence: true
end
