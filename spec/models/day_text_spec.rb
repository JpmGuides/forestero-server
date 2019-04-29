require 'rails_helper'

RSpec.describe DayText, type: :model do
  it "should create a day_text with factory" do
    user = FactoryGirl.build(:day_text)

    expect {
      user.save!
    }.to change(DayText, :count).by(1)
  end
end
