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
                        },
                        format: :js
          }.to change(question.answers, :count).by(1)
        end

        it 'saves a new answer in the database with question relation' do
          expect { post :create,
                        params: {
                          question_id: question,
                          answer: attributes_for(:answer)
                        },
                        format: :js
          }.to change(question.answers, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect { post :create,
                        params: {
                          question_id: question,
                          answer: attributes_for(:answer, :invalid)
                        },
                        format: :js
          }.to_not change(Answer, :count)
        end
      end

      it 'renders create' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end
    end

    describe 'PATCH #update' do
      context 'author with valid params' do
        let(:answer) { create(:answer, author: user) }

        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new_title' } }, format: :js
          answer.reload

          expect(answer.body).to eq 'new_title'
        end
      end

      context 'no author with valid params' do
        it 'not changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new_title' } }, format: :js
          answer.reload

          expect(answer.body).to_not eq 'new_title'
        end
      end

      context 'invalid params' do
        before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js }

        it 'does not change answer' do
          text = answer.body
          answer.reload

          expect(answer.body).to eq text
        end
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :update
      end
    end

    describe 'DELETE #destroy' do
      context 'Author' do
        let!(:answer) { create(:answer, author: user) }

        it 'deletes the answer' do
          expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
        end
      end

      context 'No author' do
        let!(:answer) { create(:answer) }

        it 'cannot delete the answer' do
          expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
        end
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end
end
