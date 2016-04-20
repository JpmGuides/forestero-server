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

  describe "Tree#transpose_params" do
    it 'should transform string to parameters hash' do
      params = Tree.transpose_params("(1,2,3,1,1,1,2)")

      expect(params).to be_a(Hash)
    end

    it 'should transform string to parameters hash' do
      params = Tree.transpose_params("(1,2,3,1,1,1,2)")

      expect(params).to be_a(Hash)
    end

    it 'should contains attributes as keys' do
      params = Tree.transpose_params("(1,2,3,1,1,1,2)")
      params_keys = params.keys.map(&:to_s)
      attributes = Tree.column_names

      expect(params_keys - attributes).to be_empty
    end

    it 'should return an empty Hash if not parsable' do
      params = Tree.transpose_params(1)

      expect(params).to be_empty
    end
  end

  describe "#to_csv" do
    it 'should return an array with the vlaues' do
      tree = FactoryGirl.create(:tree)

      expect(tree.to_csv).to eq([tree.tiny, tree.small, tree.large, tree.mature, tree.rife, tree.damaged, tree.blackpod])
    end
  end
end
