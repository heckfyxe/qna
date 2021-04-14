require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) {
    { 'CONTENT-TYPE': 'application/json',
      'ACCEPT': 'application/json' }
  }

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'authorized' do
      let(:profile) { create(:user) }
      let(:profile_response) { json['me'] }
      let(:access_token) { create(:access_token, resource_owner_id: profile.id) }
      let(:headers) {
        { 'CONTENT-TYPE': 'application/json',
          'ACCEPT': 'application/json',
          'Authorization': 'Bearer ' + access_token.token }
      }

      before { get '/api/v1/profiles/me', headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it_behaves_like 'user field' do
        let(:user) { profile }
        let(:user_response) { profile_response }
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles' }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let!(:profiles) { create_list(:user, 3) }
      let(:profile) { profiles.first }

      let(:profiles_response) { json['profiles'] }
      let(:profile_response) { profiles_response.first }

      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:headers) {
        { 'CONTENT-TYPE': 'application/json',
          'ACCEPT': 'application/json',
          'Authorization': 'Bearer ' + access_token.token }
      }

      before { get '/api/v1/profiles', headers: headers }

      it 'returns list of profiles' do
        expect(profiles_response.size).to eq 3
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it_behaves_like 'user field' do
        let(:user) { profile }
        let(:user_response) { profile_response }
      end
    end
  end
end