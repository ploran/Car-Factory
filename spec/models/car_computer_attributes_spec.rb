require "rails_helper"

RSpec.describe CarComputer, :type => :model do
  subject {
    described_class.new(name: "Computer")}

  it "is valid with valid relationships" do
    expect(subject).to be_valid
  end

  it "is not valid without a name" do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it "is not valid with the same name" do
    subject.save!
    another_computer = described_class.new(name: "Computer")
    expect(another_computer).to_not be_valid
  end
end
