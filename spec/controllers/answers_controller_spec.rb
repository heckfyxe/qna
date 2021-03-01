require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'GET #index' do
    let(:answers) { create_list(:answer, 3, question: question) }

    before { get :index, params: { question_id: question } }

    it 'populates an array of all answers of question' do
      create_list(:answer, 5)
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it 'renders show view' do
      get :show, params: { id: answer }
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    it 'renders new view' do
      get :new, params: { question_id: question }
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    it 'renders edit view' do
      get :edit, params: { id: answer }
      expect(response).to render_template :edit
    end
  end

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

      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:answer)
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

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template :new
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

      it 'redirects to updated answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to(answer)
      end
    end

    context 'invalid params' do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) } }

      it 'does not change answer' do
        answer.reload

        expect(answer.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer) }

    it 'deletes the answer' do
      expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to question_answers_path(answer.question)
    end
  end
end
