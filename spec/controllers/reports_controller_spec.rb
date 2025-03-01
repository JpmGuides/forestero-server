require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  describe "POST #create" do
    describe 'with valid params' do
      let(:post_data) { "p1=28/01/2016&p2=DI01&p3=2&p4=6&p5=4&p6=3&p7=3&p8=4&p9=3&p10=false&p11=false&p12=true&p13=true&p14=true&t1=(1,2,3,1,1,1,2)&t2=(99,2,5,100,0,0,0)&t3=(2,2,44,2,0,2,0)&t4=(0,0,0,0,0,0,1)&t5=(1,1,1,1,1,1,1)&s1=test&s2=test&s3=test&s4=test4&s5=test5&d1=werwerwerwer" }

      it 'should be success' do
        request.env['RAW_POST_DATA'] = post_data
        post :create

        expect(response).to be_success
      end

      it 'should create a report' do
        request.env['RAW_POST_DATA'] = post_data

        expect {
          post :create
        }.to change(Report, :count).by(1)
      end

      it 'should create a device if not exists' do
        request.env['RAW_POST_DATA'] = post_data + '&d1=1234567890'

        expect {
          post :create
        }.to change(Device, :count).by(1)
      end

      it 'should be link with a device device' do
        request.env['RAW_POST_DATA'] = post_data + '&d1=1234567890'

        post :create

        expect(assigns(:report)).to be_a(Report)
        expect(assigns(:report).device).to be_a(Device)
      end

      it 'should create nested trees' do
        request.env['RAW_POST_DATA'] = post_data

        expect {
          post :create
        }.to change(Tree, :count).by(5)
      end

      it 'should remove params demo if uuid = 71739E5944834FAC8EF9CA534CE20240' do
        post_data =  "p1=28/01/2016&p2=DI01&p3=2&p4=6&p5=4&p6=3&p7=3&p8=4&p9=3&p10=false&p11=false&p12=true&p13=true&p14=true&t1=(1,2,3,1,1,1,2)&t2=(99,2,5,100,0,0,0)&t3=(2,2,44,2,0,2,0)&t4=(0,0,0,0,0,0,1)&t5=(1,1,1,1,1,1,1)&s1=test&s2=test&s3=test&s4=test4&s5=test5&d1=71739E5944834FAC8EF9CA534CE20240&d2=1"
        request.env['RAW_POST_DATA'] = post_data

        post :create

        expect(assigns(:report)).to be_a(Report)
        expect(assigns(:report).demo).to eql(false)
      end
    end

    describe 'with invalid params' do
      let(:post_data) { "asgfasdfwer" }

      it 'should be success' do
        request.env['RAW_POST_DATA'] = post_data
        post :create

        expect(response).to be_bad_request
      end
    end
  end
end
