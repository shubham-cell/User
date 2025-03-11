require 'rails_helper'

RSpec.describe NewUser, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = NewUser.new(name: 'John Doe', email: 'john.doe@example.com', password: 'password')
      expect(user).to be_valid
    end

    it 'is not valid without a name' do
      user = NewUser.new(name: nil, email: 'john.doe@example.com')
      expect(user).to_not be_valid
    end

    it 'is not valid without an email' do
      user = NewUser.new(name: 'John Doe', email: nil)
      expect(user).to_not be_valid
    end

    it 'is not valid with an invalid email' do
      user = NewUser.new(name: 'John Doe', email: 'not_an_email')
      expect(user).to_not be_valid
    end

    it 'is not valid with an password' do
      user = NewUser.new(name: 'John Doe', email: 'john.doe@example.com', password: nil)
      expect(user).to_not be_valid
    end
  end
end
