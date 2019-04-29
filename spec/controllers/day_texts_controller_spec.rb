require 'rails_helper'

RSpec.describe DayTextsController, type: :controller, focus: true do

  describe "POST #create" do
    describe 'with valid params' do
      login_user
      let(:valid_params) { FactoryGirl.attributes_for(:day_text) }

      it 'should be success' do
        post :create, params: { day_text: valid_params }

        expect(response).to be_success
      end

      it 'should create a report' do
        expect {
          post :create, params: { day_text: valid_params }
        }.to change(DayText, :count).by(1)
      end

      it 'should update a record if same date create a report' do
        DayText.create(valid_params)

        expect {
          post :create, params: { day_text: valid_params }
        }.to_not change(DayText, :count)
      end
    end

    describe 'with invalid params' do
      login_user
      let(:invalid_params) { {text: 'test'} }

      it "should render error" do
        post :create, params: { day_text: invalid_params }

        expect(response).to be_bad_request
      end
    end

    describe 'unhautorize user' do
      login_normal_user
      let(:valid_params) { FactoryGirl.attributes_for(:day_text) }

      it 'should be 401' do
        post :create, params: { day_text: valid_params }

        expect(response).to be_unauthorized
      end
    end
  end
end
