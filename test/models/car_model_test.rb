require 'test_helper'

class CarModelTest < ActiveSupport::TestCase
  def setup
        @model = CarModel.new(name: "Nombre Ejemplo")
    end

    test "name should be unique" do
        duplicate_model = @model.dup
        @model.save
        assert_not duplicate_model.valid?
    end

    test "name should be present" do
      model = CarModel.new
      model.save
      assert_not model.valid?
    end
end
