require 'rails_helper'

RSpec.describe Report, type: :model do
  it "should create a report with factory" do
    report = FactoryGirl.build(:report)

    expect {
      report.save!
    }.to change(Report, :count).by(1)
  end

  it "should create a complete report with factory" do
    report = FactoryGirl.build(:report, :complete)

    expect {
      report.save!
    }.to change(Report, :count).by(1)
  end
end
