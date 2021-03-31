require 'rails_helper'

RSpec.describe BadgesController, type: :controller do
  describe 'GET #index' do
    context 'Authenticated user' do
      let(:user) { create(:user) }

      before { sign_in(user) }

      it 'renders index template' do
        get :index
        expect(response).to render_template :index
      end
    end

    context 'Unauthenticated user' do
      it 'does not render index template' do
        get :index
        expect(response).to_not render_template :index
      end
    end
  end
end
