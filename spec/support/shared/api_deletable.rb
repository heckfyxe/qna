shared_examples_for 'API Deletable' do
  let(:access_token) { create(:access_token) }
  let(:headers) {
    { 'CONTENT-TYPE': 'application/json',
      'ACCEPT': 'application/json',
      'Authorization': 'Bearer ' + access_token.token }
  }

  before { delete api_path, headers: headers }

  it 'returns 200 status' do
    expect(response).to be_successful
  end

  it 'deletes the question' do
    expect { model.reload }.to raise_exception ActiveRecord::RecordNotFound
  end
end
