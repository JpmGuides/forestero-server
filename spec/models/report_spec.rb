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
      "p14"=>"true",
      "s1"=>"true",
      "s2"=>"2.3434535",
      "s3"=>"3.4353453",
      "s4"=>"+5.000",
      "s5"=>"26+",
      "d1"=>"4354565646456456"
    }
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

    it 'should create device if not exist' do
      device = FactoryGirl.build(:device)
      params = report_params
      params['d1'] = device.uuid

      expect {
        Report.transpose_params(report_params)
      }.to change(Device, :count).by(1)
    end

    it 'should not create device if exist' do
      device = FactoryGirl.create(:device)
      params = report_params
      params['d1'] = device.uuid

      expect {
        Report.transpose_params(report_params)
      }.to_not change(Device, :count)
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

  describe "Report#to_csv" do
    it 'should return a csv string' do
      report = FactoryGirl.create(:report)
       FactoryGirl.create_list(:tree, 3, report: report)

      expect(Report.to_csv).to be_a(String)
    end
  end

  describe "#to_csv" do
    it 'should return an array with the vlaues' do
      report = FactoryGirl.create(:report)

      expect(report.to_csv).to eq([
        report.taken_at, report.site_reference, report.site_longitude, report.site_latitude, report.site_age, report.device,
        report.humidity, report.canopy, report.leaf, report.maintenance, report.flowers,
        report.bp, report.wilt, report.harvesting, report.drying, report.fertilizer])
    end

    it 'should call to_csv for belonging trees' do
      report = FactoryGirl.create(:report)
      trees = FactoryGirl.create_list(:tree, 3, report: report)

      expect(report.to_csv.count).to eq(16 + trees.count * 7)
    end

    it 'should call to_csv for 5 maximum belonging trees' do
      report = FactoryGirl.create(:report)
      FactoryGirl.create_list(:tree, 8, report: report)

      expect(report.to_csv.count).to eq(16 + 5 * 7)
    end
  end
end
