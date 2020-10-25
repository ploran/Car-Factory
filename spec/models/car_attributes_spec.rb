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

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a car model" do
    subject.car_model = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a year" do
    subject.year = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a price" do
    subject.price = 10
    expect(subject).to_not be_valid
  end

  it "is not valid without a cost_price" do
    subject.cost_price = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a seats" do
    subject.seats = nil
    expect(subject).to_not be_valid
  end

  it "is not valid with more than 4 wheels" do
    subject.wheels = 5
    expect(subject).to_not be_valid
  end

  it "is not valid with more than 2 seats" do
    subject.seats = 3
    expect(subject).to_not be_valid
  end

  it "is not valid with cost price greater than price" do
    subject.price = 50000
    subject.cost_price = 60000
    expect(subject).to_not be_valid
  end

end
