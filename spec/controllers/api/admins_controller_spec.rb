require 'rails_helper'

RSpec.describe Api::AdminsController, type: :controller do
  describe 'GET index' do
    context 'as authenticated admin' do
      let(:admin) { create(:admin) }
      before do
        authenticated_header(request, admin)
        get :index
      end

      it 'returns http status success' do
        expect(response).to have_http_status(:success)
      end

      it 'JSON body response contains expected recipe attributes' do
        json_response = JSON.parse(response.body)
        expect(json_response.try(:first).keys).to match_array(%w[id name nickname email created_at password_digest updated_at])
      end
    end

    context 'as unauthenticated admin' do
      let(:admin) { create(:admin) }
      before do
        get :index
      end

      it 'returns http status unauthorized' do
        expect(response).to be_unauthorized
      end
    end
  end

  describe 'GET show' do
    context 'as authenticated admin' do
      let(:admin) { create(:admin) }

      before do
        authenticated_header(request, admin)
        get :index
      end

      it 'returns http status success' do
        expect(response).to have_http_status(:success)
      end

      it 'JSON body response contains expected recipe attributes' do
        json_response = JSON.parse(response.body)
        expect(json_response.try(:first).keys).to match_array(%w[id name nickname email created_at password_digest updated_at])
      end
    end

    context 'as unauthenticated admin' do
      let(:admin) { create(:admin) }
      before do
        get :index
      end

      it 'returns http status unauthorized' do
        expect(response).to be_unauthorized
      end
    end
  end

  describe 'POST create' do
    context 'with valid params' do
      let(:admin) { build(:admin) }
      let(:params) do
        { name: admin.name, nickname: admin.nickname, email: admin.email,
          password: 'qwerty12345', password_confirmation: 'qwerty12345' }
      end

      before do
        post :create, params: params
      end

      it 'returns http status success' do
        expect(response).to have_http_status(:success)
      end

      it 'JSON body response contains expected recipe attributes' do
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to match_array(%w[id name nickname email created_at password_digest updated_at])
      end
    end

    context 'with invalid params' do
      let(:admin) { build(:admin) }
      let(:params) do
        { name: admin.name, nickname: admin.nickname, email: 'dfasd',
          password: 'qwer', password_confirmation: 'qwerty' }
      end

      before do
        post :create, params: params
      end

      it 'returns http status success' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT update' do
    context 'with valid params' do
      let(:admin) { create(:admin) }
      let(:new_params) do
        { id: admin.id, name: 'Misha Push', nickname: 'Gufy' }
      end

      before do
        authenticated_header(request, admin)
        put :update, params: new_params
        admin.reload
      end

      it 'returns http status success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns update message' do
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Attributes updated')
      end
    end

    context 'with invalid params' do
      let(:admin) { create(:admin) }
      let(:admin_2) { create(:admin) }
      let(:new_params) do
        { id: admin_2.id, name: nil, nickname: nil }
      end

      before do
        authenticated_header(request, admin)
      end

      it 'returns http status unprocessable entity' do
        put :update, params: new_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error: admin not found' do
        put :update, params: { id: 13_441, name: 'Misha Push', nickname: 'asdfsfads' }
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to eq('Admin with id 13441 not found')
      end
    end
  end

  describe 'DELETE destroy' do
    context 'existing user' do
      let(:admin) { create(:admin) }
      let(:admin_2) { create(:admin) }
      let(:new_params) { { id: admin_2.id } }

      before do
        authenticated_header(request, admin)
        delete :destroy, params: new_params
      end

      it 'returns http status success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns destroy message' do
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('User destroyed')
      end
    end

    context 'unexisted user' do
      let(:admin) { create(:admin) }
      let(:new_params) { { id: 124_531 } }

      before do
        authenticated_header(request, admin)
        delete :destroy, params: new_params
      end

      it 'returns error: admin not found' do
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to eq("Admin with id #{new_params[:id]} not found")
      end
    end
  end
end
