require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #vote_up' do
    context 'Author' do
      let!(:question) { create(:question, author: user) }

      before { sign_in(user) }

      it 'cannot vote up the question' do
        expect { post :vote_up, params: { question_id: question } }.to_not change(Vote, :count)
      end
    end

    context 'No author' do
      before { sign_in(user) }

      it 'votes up the question' do
        expect { post :vote_up, params: { question_id: question } }.to change(Vote, :count).by(1)
        expect(Vote.order(created_at: :asc).last.value).to be_positive
      end
    end

    it 'cannot vote up the question' do
      expect { post :vote_up, params: { question_id: question } }.to_not change(Vote, :count)
    end
  end

  describe 'POST #vote_down' do
    context 'Author' do
      let!(:question) { create(:question, author: user) }

      it 'cannot vote down the question' do
        expect { post :vote_down, params: { question_id: question } }.to_not change(Vote, :count)
      end
    end

    context 'No author' do
      before { sign_in(user) }

      it 'votes down the question' do
        expect { post :vote_down, params: { question_id: question } }.to change(Vote, :count).by(1)
        expect(Vote.order(created_at: :asc).last.value).to be_negative
      end
    end

    it 'cannot vote down the question' do
      expect { post :vote_down, params: { question_id: question } }.to_not change(Vote, :count)
    end
  end
end
