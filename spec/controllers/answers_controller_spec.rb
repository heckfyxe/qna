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
                        format: :json
          }.to change(question.answers, :count).by(1)
        end

        it 'saves a new answer in the database with question relation' do
          expect { post :create,
                        params: {
                          question_id: question,
                          answer: attributes_for(:answer)
                        },
                        format: :json
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
                        format: :json
          }.to_not change(Answer, :count)
        end
      end

      it 'renders create' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :json
        expect(response.body).to eq question.answers.last.to_json
      end
    end

    describe 'PATCH #update' do
      context 'author with' do
        let(:answer) { create(:answer, author: user) }

        context 'valid params' do
          it 'changes answer attributes' do
            patch :update, params: { id: answer, answer: { body: 'new_title' } }, format: :js
            answer.reload

            expect(answer.body).to eq 'new_title'
          end

          it 'renders update view' do
            patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
            expect(response).to render_template :update
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
      end

      context 'no author' do
        it 'not changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new_title' } }, format: :js
          answer.reload

          expect(answer.body).to_not eq 'new_title'
        end

        it 'renders js alert' do
          patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
          expect(response.body).to eq "alert('You are not authorized to access this page.')"
        end
      end
    end

    describe 'DELETE #destroy' do
      context 'Author' do
        let!(:answer) { create(:answer, author: user) }

        it 'deletes the answer' do
          expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
        end
      end

      context 'No author' do
        let!(:answer) { create(:answer) }

        it 'cannot delete the answer' do
          expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
        end
      end

      it 'render js alert' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response.body).to eq "alert('You are not authorized to access this page.')"
      end
    end

    describe 'POST #mark_as_the_best' do
      context 'Author of question' do
        let(:question) { create(:question, author: user) }
        let(:the_best_answer) { create(:answer, :the_best, question: question) }
        let(:answer) { create(:answer, question: question) }

        it 'changes the best answer' do
          the_best_answer
          post :mark_as_the_best, params: { id: answer }, format: :js

          the_best_answer.reload
          answer.reload

          expect(the_best_answer.the_best?).to be_falsey
          expect(answer.the_best?).to be_truthy
        end

        it 'renders mark_as_the_best script' do
          post :mark_as_the_best, params: { id: answer }, format: :js
          expect(response).to render_template :mark_as_the_best
        end
      end

      context "No author of question" do
        let(:answer) { create(:answer, question: question) }

        it "cannot choose the best answer" do
          expect { post :mark_as_the_best, params: { id: answer }, format: :js }.to_not change(Answer.the_best, :ids)
        end

        it 'renders js alert' do
          post :mark_as_the_best, params: { id: answer }, format: :js
          expect(response.body).to eq "alert('You are not authorized to access this page.')"
        end
      end
    end
  end
end
