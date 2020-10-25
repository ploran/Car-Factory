require "rails_helper"

RSpec.describe "Car Models", :type => :model do
    it "is valid with with name" do
      model = CarModel.new(name: "Modelo A")
      expect(model).to be_valid
    end
    it "is not valid without a name" do
      model = CarModel.new(name: nil)
      expect(model).to_not be_valid
  end
end
