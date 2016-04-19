require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  login_user

  describe "GET #index" do
    it "should returns http success" do
      get :index

      expect(response).to have_http_status(:success)
    end

    it 'should render index template' do
      get :index

      expect(response).to render_template(:index)
    end

    it 'should shows the list of users (with the current)' do
      FactoryGirl.create_list(:user, 4)

      get :index

      expect(assigns(:users)).to be_a(ActiveRecord::Relation)
      expect(assigns(:users).count).to equal(5)
    end
  end

  describe "GET #new" do
    it "should returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end

    it 'should render new template' do
      get :new

      expect(response).to render_template(:new)
    end

    it 'should build a new user' do
      get :new

      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST #create" do
    describe 'with valid params' do
      it "should redirect to index" do
        user_attributes = FactoryGirl.attributes_for(:user)
        post :create, params: { user: user_attributes }

        expect(response).to redirect_to(:users)
      end

      it 'should create a user' do
        user_attributes = FactoryGirl.attributes_for(:user)

        expect {
          post :create, params: { user: user_attributes }
        }.to change(User, :count).by(1)
      end

      it 'should create a user with the right attributes' do
        user_attributes = FactoryGirl.attributes_for(:user)
        post :create, params: { user: user_attributes }

        expect(assigns(:user).email).to eq(user_attributes[:email])
      end
    end

    describe 'with invalid params' do
      it "should render to new" do
        user_attributes = { email: 'test@test.com', password: '', password_confirmation: '' }
        post :create, params: { user: user_attributes }

        expect(response).to render_template(:new)
      end

      it "should not create new user" do
        user_attributes = { email: 'test@test.com', password: '12345678', password_confirmation: '' }

        expect {
          post :create, params: { user: user_attributes }
        }.to_not change(User, :count)
      end

      it "should not create new user if email alredy exists" do
        email = Faker::Internet.email
        previously_created_user = FactoryGirl.create(:user, email: email)
        user_attributes = FactoryGirl.attributes_for(:user, email: email)

        expect(previously_created_user.email).to eq(user_attributes[:email])

        expect {
          post :create, params: { user: user_attributes }
        }.to_not change(User, :count)
      end
    end
  end

  describe "GET #edit" do
    it "should returns http success" do
      user = FactoryGirl.create(:user)
      get :edit, params: { id: user.id }

      expect(response).to have_http_status(:success)
    end

    it 'should render edit template' do
      user = FactoryGirl.create(:user)
      get :edit, params: { id: user.id }

      expect(response).to render_template(:edit)
    end

    it 'should assigns user' do
      user = FactoryGirl.create(:user)
      get :edit, params: { id: user.id }

      expect(assigns(:user)).to eq(user)
    end

    it "should be 404 if user id not present" do
      expect {
        get :edit, params: { id: 10 }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "PUT #update" do
    describe 'with valid params' do
      it "should redirect to index" do
        user = FactoryGirl.create(:user)
        user_attributes = FactoryGirl.attributes_for(:user, email: user.email)

        put :update, params: { id: user.id, user: user_attributes }

        expect(response).to redirect_to(:users)
      end

      it 'should create a user' do
        user = FactoryGirl.create(:user)
        user_attributes = FactoryGirl.attributes_for(:user, email: user.email)

        expect {
          put :update, params: { id: user.id, user: user_attributes }
        }.to_not change(User, :count)

        expect(response).to redirect_to(:users)
      end

      it 'should create a user with the right attributes' do
        user = FactoryGirl.create(:user)
        user_attributes = FactoryGirl.attributes_for(:user, email: user.email)

        put :update, params: { id: user.id, user: user_attributes }

        expect(assigns(:user).email).to eq(user_attributes[:email])
      end
    end

    describe 'with invalid params' do
      it "should render to new" do
        user = FactoryGirl.create(:user)
        user_attributes = FactoryGirl.attributes_for(:user, email: user.email, password: '', password_confirmation: '')

        put :update, params: { id: user.id, user: user_attributes }

        expect(response).to render_template(:edit)
      end

      it "should not create new user" do
        user = FactoryGirl.create(:user)
        user_attributes = FactoryGirl.attributes_for(:user, email: user.email, password: '', password_confirmation: '')

        put :update, params: { id: user.id, user: user_attributes }

        expect(response).to render_template(:edit)
      end

      it "should not update user with a new email if email alredy exists" do
        user1 = FactoryGirl.create(:user)
        user2 = FactoryGirl.create(:user)

        expect(user1.email).to_not eq(user2.email)

        user_attributes = FactoryGirl.attributes_for(:user, email: user1.email)

        put :update, params: { id: user2.id, user: user_attributes }

        expect(response).to render_template(:edit)
      end

      it "should raise error if user id not present" do
        expect {
          put :update, params: { id: 10 }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
