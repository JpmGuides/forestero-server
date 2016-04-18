require 'rails_helper'

RSpec.describe User, type: :model do
  it "should create a user with factory" do
    user = FactoryGirl.build(:user)

    expect {
      user.save!
    }.to change(User, :count).by(1)
  end
end
