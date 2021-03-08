require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  context 'Authenticated user' do
    let(:user) { create(:user) }
    before { login(user) }

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect { post :create,
                        params: {
                          question_id: question,
                          answer: attributes_for(:answer)
                        }
          }.to change(question.answers, :count).by(1)
        end

        it 'saves a new answer in the database with question relation' do
          expect { post :create,
                        params: {
                          question_id: question,
                          answer: attributes_for(:answer)
                        }
          }.to change(question.answers, :count).by(1)
        end

        it 'redirects to question' do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect { post :create,
                        params: {
                          question_id: question,
                          answer: attributes_for(:answer, :invalid)
                        }
          }.to_not change(Answer, :count)
        end

        it 'redirects to question' do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
          expect(response).to redirect_to question_path(question)
        end
      end
    end

    describe 'PATCH #update' do
      context 'valid params' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new_title' } }
          answer.reload

          expect(answer.body).to eq 'new_title'
        end

        it 'redirects to question' do
          patch :update, params: { id: answer, answer: attributes_for(:answer) }
          expect(response).to redirect_to question_path(answer.question)
        end
      end

      context 'invalid params' do
        before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) } }

        it 'does not change answer' do
          text = answer.body
          answer.reload

          expect(answer.body).to eq text
        end

        it 'redirects to question' do
          expect(response).to redirect_to question_path(answer.question)
        end
      end
    end

    describe 'DELETE #destroy' do
      let!(:answer) { create(:answer) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end
end
