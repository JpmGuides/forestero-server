require 'rails_helper'

RSpec.describe Report, type: :model do
  let(:report_params) {
    { "p1"=>"28/01/2016",
      "p2"=>"DI01",
      "p3"=>"2",
      "p4"=>"6",
      "p5"=>"4",
      "p6"=>"3",
      "p7"=>"3",
      "p8"=>"4",
      "p9"=>"3",
      "p10"=>"true",
      "p11"=>"true",
      "p12"=>"false",
      "p13"=>"false",
      "p14"=>"true" }
  }

  let(:trees_param) {
    { "t1"=>"(1,2,3,1,1,1,2)",
      "t2"=>"(99,2,5,100,0,0,0)",
      "t3"=>"(2,2,44,2,0,2,0)",
      "t4"=>"(0,0,0,0,0,0,1)",
      "t5"=>"(1,1,1,1,1,1,1)" }
  }

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

  describe "Report#transpose_params" do
    it 'should transforme hash with "px" params to attributes' do
      params = Report.transpose_params(report_params)
      params_keys = params[:report].keys.map(&:to_s)
      attributes = Report.column_names

      expect(params_keys - attributes).to eq(["trees_attributes"])
    end

    it "should call transpose_trees_params" do
      expect(Report).to receive(:transpose_trees_params)

      Report.transpose_params(report_params)
    end

    it 'should return empty params if param cannot be parsed' do
      expect(Report.transpose_params('test')).to be_empty
    end
  end

  describe "Report#transpose_trees_params" do
    it "should call Tree.transpose params for each t param" do
      expect(Tree).to receive(:transpose_params).exactly(5)

      Report.transpose_trees_params(trees_param)
    end

    it "should have an array memeber per tx param" do
      params = Report.transpose_trees_params(trees_param)

      expect(params.count).to eq(5)
    end
  end
end
