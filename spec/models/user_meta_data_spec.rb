require 'rails_helper'

RSpec.describe UserMetaData, type: :model do
  it 'is valid with valid attributes' do
    user = FactoryBot.create(:user_meta_data)
    expect(user).to be_valid
  end
end
