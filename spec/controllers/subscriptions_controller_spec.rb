require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:question) { create(:question) }
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'POST #create' do
    it 'subscribes the user' do
      question
      expect { post :create, params: { question_id: question }, format: :js }.to change(Subscription, :count).by(1)
    end
  end

  describe 'POST #destroy' do
    let!(:subscription)  { create(:subscription, question: question, user: user) }

    it 'unsubscribes the user' do
      question
      expect { delete :destroy, params: { question_id: question }, format: :js }.to change(Subscription, :count).by(-1)
    end
  end
end
