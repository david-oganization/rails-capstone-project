require 'rails_helper'

RSpec.describe GroupController, type: :controller do
  let(:user) { create(:user) }
  let(:group1) { create(:group, user:) }

  describe 'GET #index' do
    context 'when user is authenticated' do
      before do
        sign_in user
      end

      it 'renders the index template' do
        get :index
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:index)
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to sign in page' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #show' do
    context 'when user is authenticated' do
      before do
        sign_in user
      end

      it 'renders the show template' do
        get :show, params: { id: group1.id }
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:show)
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to sign in page' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is authenticated' do
      before do
        sign_in user
      end

      context 'with incorrect params' do
        it 'returns error response' do
          post :create, params: { group: { name: '' } }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template(:new)
        end
      end

      context 'with correct params' do
        it 'returns success response' do
          post :create, params: { group: { name: 'G1' } }
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(group_index_path)
        end
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to sign in page' do
        post :create, params: { group: {} }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
