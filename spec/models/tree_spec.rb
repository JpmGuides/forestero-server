require 'rails_helper'

RSpec.describe Tree, type: :model do
  describe "factories" do
    it "should create a tree with factory" do
      tree = FactoryGirl.build(:tree)

      expect {
        tree.save!
      }.to change(Tree, :count).by(1)
    end

    it "should create parent report" do
      expect {
        FactoryGirl.build(:tree)
      }.to change(Report, :count).by(1)
    end


    it "should create a complete tree with factory" do
      tree = FactoryGirl.build(:tree, :complete)

      expect {
        tree.save!
      }.to change(Tree, :count).by(1)
    end
  end
end
