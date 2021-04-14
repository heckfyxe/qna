shared_examples_for 'user field' do
  it 'returns all public fields' do
    %w[id email admin created_at updated_at].each do |attr|
      expect(user_response[attr]).to eq user.send(attr).as_json
    end
  end

  it "doesn't returns all private fields" do
    %w[password encrypted_password].each do |attr|
      expect(user_response).to_not have_key(attr)
    end
  end
end
