require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) {
    { 'CONTENT-TYPE': 'application/json',
      'ACCEPT': 'application/json' }
  }

  shared_examples_for "common fields" do
    it 'returns all public fields' do
      %w[id body the_best created_at updated_at].each do |attr|
        expect(answer_response[attr]).to eq answer.send(attr).as_json
      end
    end
  end

  describe 'GET /api/v1/questions/:question_id/answers' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions/1/answers' }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:headers) {
        { 'CONTENT-TYPE': 'application/json',
          'ACCEPT': 'application/json',
          'Authorization': 'Bearer ' + access_token.token }
      }

      let!(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }

      let(:answers_response) { json['answers'] }
      let(:answer_response) { answers_response.first }

      before { get "/api/v1/questions/#{question.id}/answers", headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(answers_response.size).to eq 2
      end

      it_behaves_like 'common fields'
      it_behaves_like 'user field' do
        let(:user) { answer.author }
        let(:user_response) { answer_response['author'] }
      end

      it "doesn't return private fields" do
        %w[files links comments].each do |attr|
          expect(answer_response).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/answers/1' }
    end

    context 'authorized' do
      let!(:answer) { create(:answer, :with_attachment) }
      let!(:comments) { create_list(:comment, 3, commentable: answer) }
      let!(:links) { create_list(:link, 2, linkable: answer) }

      let(:answer_response) { json['answer'] }

      let(:access_token) { create(:access_token) }
      let(:headers) {
        { 'CONTENT-TYPE': 'application/json',
          'ACCEPT': 'application/json',
          'Authorization': 'Bearer ' + access_token.token }
      }

      before { get "/api/v1/answers/#{answer.id}", headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it_behaves_like 'common fields'

      describe 'files' do
        let(:files) { answer.files }
        let(:files_response) { answer_response['files'] }

        it_behaves_like 'files field'
      end

      describe 'links' do
        let(:link) { links.first }

        let(:links_response) { answer_response['links'] }
        let(:link_response) { links_response.first }

        it_behaves_like 'links field'
      end

      describe 'comments' do
        let(:comment) { comments.first }

        let(:comments_response) { answer_response['comments'] }
        let(:comment_response) { comments_response.first }

        it_behaves_like 'comments field'
      end

      describe 'question' do
        let(:question) { answer.question }
        let(:question_response) { answer_response['question'] }

        it_behaves_like 'question field'
      end
    end
  end

  describe 'POST /api/v1/answers' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions/1/answers' }
    end

    context 'authorized' do
      let!(:question) { create(:question) }

      let!(:links) { attributes_for_list(:link, 2) }

      let(:params) { attributes_for(:answer, links: links, the_best: true) }

      let(:answer_response) { json['answer'] }

      let(:access_token) { create(:access_token) }
      let(:headers) {
        { 'CONTENT-TYPE': 'application/json',
          'ACCEPT': 'application/json',
          'Authorization': 'Bearer ' + access_token.token }
      }

      before { post "/api/v1/questions/#{question.id}/answers", params: params.to_json, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[body the_best].each do |attr|
          expect(answer_response[attr]).to eq params[attr.to_sym].as_json
        end
      end

      describe 'links' do
        let(:link) { links.first }

        let(:links_response) { answer_response['links'] }
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

  describe 'PUT /api/v1/answers/:id' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/answers/1' }
    end

    context 'authorized' do
      let!(:answer) { create(:answer) }

      let(:params) { attributes_for(:answer, the_best: true) }

      let(:answer_response) { json['answer'] }

      let(:access_token) { create(:access_token) }
      let(:headers) {
        { 'CONTENT-TYPE': 'application/json',
          'ACCEPT': 'application/json',
          'Authorization': 'Bearer ' + access_token.token }
      }

      before { put "/api/v1/answers/#{answer.id}", params: params.to_json, headers: headers }
      before { answer.reload }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'updates fields' do
        %w[body the_best].each do |attr|
          expect(answer.send(attr)).to eq params[attr.to_sym]
        end
      end

      it 'returns updated fields' do
        %w[body the_best].each do |attr|
          expect(answer_response[attr]).to eq params[attr.to_sym]
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
        let!(:model) { create(:answer) }
        let(:api_path) { "/api/v1/answers/#{model.id}" }
      end
    end
  end
end