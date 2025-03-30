require 'rails_helper'

RSpec.describe Budget, type: :model do
 
  it "is valid with valid attributes" do
    budget = Budget.new(new_user_id: 1, amount: 1000, budget_category: 0)
    expect(budget).to be_valid
  end


  it "is not valid without an amount" do
    budget = Budget.new(amount: nil, new_user_id: 1)
    expect(budget).to_not be_valid
  end

  it "is not valid with a negative amount" do
    budget = Budget.new(amount: -100, new_user_id: 1)
    expect(budget).to_not be_valid
  end
end
