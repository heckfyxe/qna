require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) {
    { 'CONTENT-TYPE': 'application/json',
      'ACCEPT': 'application/json' }
  }

  describe 'GET /api/v1/questions' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:headers) {
        { 'CONTENT-TYPE': 'application/json',
          'ACCEPT': 'application/json',
          'Authorization': 'Bearer ' + access_token.token }
      }

      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:questions_response) { json['questions'] }
      let(:question_response) { questions_response.first }

      before { get '/api/v1/questions', headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(questions_response.size).to eq 2
      end

      it_behaves_like 'question field'
      it_behaves_like 'user field' do
        let(:user) { question.author }
        let(:user_response) { question_response['author'] }
      end

      it "doesn't return private fields" do
        %w[files links comments].each do |attr|
          expect(question_response).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions/1' }
    end

    context 'authorized' do
      let!(:question) { create(:question, :with_attachment) }
      let!(:comments) { create_list(:comment, 3, commentable: question) }
      let!(:links) { create_list(:link, 2, linkable: question) }

      let(:question_response) { json['question'] }

      let(:access_token) { create(:access_token) }
      let(:headers) {
        { 'CONTENT-TYPE': 'application/json',
          'ACCEPT': 'application/json',
          'Authorization': 'Bearer ' + access_token.token }
      }

      before { get "/api/v1/questions/#{question.id}", headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it_behaves_like 'question field'

      describe 'files' do
        let(:files) { question.files }
        let(:files_response) { question_response['files'] }

        it_behaves_like 'files field'
      end

      describe 'links' do
        let(:link) { links.first }

        let(:links_response) { question_response['links'] }
        let(:link_response) { links_response.first }

        it_behaves_like 'links field'
      end

      describe 'comments' do
        let(:comment) { comments.first }

        let(:comments_response) { question_response['comments'] }
        let(:comment_response) { comments_response.first }

        it_behaves_like 'comments field'
      end
    end
  end

  describe 'POST /api/v1/questions' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions/1' }
    end

    context 'authorized' do
      let!(:links) { attributes_for_list(:link, 2) }

      let(:params) { attributes_for(:question, links: links) }

      let(:question_response) { json['question'] }

      let(:access_token) { create(:access_token) }
      let(:headers) {
        { 'CONTENT-TYPE': 'application/json',
          'ACCEPT': 'application/json',
          'Authorization': 'Bearer ' + access_token.token }
      }

      before { post "/api/v1/questions", params: params.to_json, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[title body].each do |attr|
          expect(question_response[attr]).to eq params[attr.to_sym].as_json
        end
      end

      describe 'links' do
        let(:link) { links.first }

        let(:links_response) { question_response['links'] }
        let(:link_response) { links_response.first }

        it 'returns all public fields' do
          %w[name url].each do |attr|
            expect(link_response[attr]).to eq link[attr.to_sym].as_json
          end

          %w[id created_at updated_at].each do |attr|
            expect(link_response).to have_key attr
          end
        end

        it "doesn't return private fields" do
          %w[linkable_type linkable_id].each do |attr|
            expect(link_response).to_not have_key(attr)
          end
        end
      end
    end
  end

  describe 'PUT /api/v1/questions/:id' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions/1' }
    end

    context 'authorized' do
      let!(:question) { create(:question) }

      let(:params) { attributes_for(:question) }

      let(:question_response) { json['question'] }

      let(:access_token) { create(:access_token) }
      let(:headers) {
        { 'CONTENT-TYPE': 'application/json',
          'ACCEPT': 'application/json',
          'Authorization': 'Bearer ' + access_token.token }
      }

      before { put "/api/v1/questions/#{question.id}", params: params.to_json, headers: headers }
      before { question.reload }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'updates fields' do
        %w[title body].each do |attr|
          expect(question.send(attr)).to eq params[attr.to_sym]
        end
      end

      it 'returns updated fields' do
        %w[title body].each do |attr|
          expect(question_response[attr]).to eq params[attr.to_sym]
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions/1' }
    end

    context 'authorized' do
      it_behaves_like 'API Deletable' do
        let!(:model) { create(:question) }
        let(:api_path) { "/api/v1/questions/#{model.id}" }
      end
    end
  end
end
