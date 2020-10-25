require "rails_helper"

RSpec.describe Car, :type => :model do
  subject {
    described_class.new(car_model: CarModel.new(name: "Modelo A"),
                        year: 2020,
                        wheels: 4,
                        chasis: "CHASIS",
                        laser: "LASER",
                        engine: "ENGINE",
                        price: 200000,
                        cost_price: 120000,
                        seats: 2,
                        car_computer: CarComputer.new(name: "Computer"))}

  it "is valid with valid relationships" do
    expect(subject).to be_valid
  end

  it "is not valid without a car model" do
    subject.car_model = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a computer" do
    subject.car_computer = nil
    expect(subject).to_not be_valid
  end


end
