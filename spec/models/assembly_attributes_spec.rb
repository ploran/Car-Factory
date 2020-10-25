require "rails_helper"

RSpec.describe Assembly, :type => :model do
  subject(:assembly) {
    described_class.new(line: 'Basic Structure', status: 0)}

  subject(:car) { Car.new(car_model: CarModel.new(name: "Modelo A"),
                          year: 2020,
                          wheels: 4,
                          chasis: "CHASIS",
                          laser: "LASER",
                          engine: "ENGINE",
                          price: 200000,
                          cost_price: 120000,
                          seats: 2,
                          car_computer: CarComputer.new(name: "Computer"),
                          assembly: assembly).save!}

  it "is not valid without present line" do
    assembly.line = nil
    expect(assembly).to_not be_valid
  end

  it "is not valid without present car" do
    assembly.car = nil
    expect(assembly).to_not be_valid
  end

  it "is not valid with without status" do
    assembly.status = nil
    expect(assembly).to_not be_valid
  end

  ['Basic Structure','Electronic devices','Paint & Final Details'].each do |valid_line|
      it "is valid with 'Basic Structure','Electronic devices','Paint & Final Details'" do
        assembly.line = valid_line
        expect(assembly).to be_valid
      end
  end

  it "is not valid with invalid Line" do
    assembly.line = 'Prueba'
    expect(assembly).to_not be_valid
  end
end
