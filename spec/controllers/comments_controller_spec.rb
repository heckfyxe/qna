require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe "#create" do
    context 'Authenticated user' do
      before { sign_in(user) }

      context 'with valid params' do
        it 'creates comment' do
          expect { post :create, params: { question_id: question, comment: attributes_for(:comment) } }.to change(Comment, :count).by(1)
        end

        it 'renders comment' do
          post :create, params: { question_id: question, comment: attributes_for(:comment) }
          expect(response).to render_template 'comments/_comment'
        end
      end

      context 'with invalid params' do
        it "doesn't create comment" do
          expect { post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid) } }.to_not change(Comment, :count)
        end

        it "renders errors" do
          post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid) }
          expect(response).to render_template 'shared/_errors'
        end
      end
    end

    it "doesn't create comment" do
      expect { post :create, params: { question_id: question } }.to_not change(Comment, :count)
    end
  end
end
