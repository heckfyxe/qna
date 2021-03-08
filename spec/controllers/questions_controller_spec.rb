require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      get :index

      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it 'renders show view' do
      get :show, params: { id: question }
      expect(response).to render_template :show
    end
  end

  context 'Authenticated user' do
    before { login(user) }

    describe 'GET #new' do
      it 'renders new view' do
        get :new
        expect(response).to render_template :new
      end
    end

    describe 'GET #edit' do
      it 'renders edit view' do
        get :edit, params: { id: question }
        expect(response).to render_template :edit
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves a new question in the database' do
          expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
        end

        it 're-renders new view' do
          post :create, params: { question: attributes_for(:question, :invalid) }
          expect(response).to render_template :new
        end
      end
    end

    describe 'PATCH #update' do
      context 'author valid params' do
        let(:question) { create(:question, author: user) }

        it 'assigns the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question) }
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          patch :update, params: { id: question, question: { title: 'new_title', body: 'new_body' } }
          question.reload

          expect(question.title).to eq 'new_title'
          expect(question.body).to eq 'new_body'
        end

        it 'redirects to updated question' do
          patch :update, params: { id: question, question: attributes_for(:question) }
          expect(response).to redirect_to(question)
        end
      end

      context 'not author valid params' do
        it 'assigns the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question) }
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          title = question.title
          body = question.body

          patch :update, params: { id: question, question: { title: 'new_title', body: 'new_body' } }
          question.reload

          expect(question.title).to eq title
          expect(question.body).to eq body
        end

        it 're-renders edit view' do
          patch :update, params: { id: question, question: attributes_for(:question) }
          expect(response).to render_template :edit
        end
      end

      context 'invalid params' do
        before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }
        it 'does not change question' do
          title = question.title
          body = question.body
          question.reload

          expect(question.title).to eq title
          expect(question.body).to eq body
        end

        it 're-renders edit view' do
          expect(response).to render_template :edit
        end
      end
    end

    describe 'DELETE #destroy' do
      context 'Author' do
        let!(:question) { create(:question, author: user) }

        it 'deletes the question' do
          expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
        end
      end

      context 'No author' do
        let!(:question) { create(:question) }

        it 'cannot delete the question' do
          expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
        end
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to question_path
      end
    end
  end
end
