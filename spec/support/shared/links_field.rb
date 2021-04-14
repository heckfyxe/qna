shared_examples_for 'links field' do
  it 'returns list of links' do
    expect(links_response.size).to eq links.size
  end

  it 'returns all public fields' do
    %w[id name url created_at updated_at].each do |attr|
      expect(link_response[attr]).to eq link.send(attr).as_json
    end
  end

  it "doesn't returns all private fields" do
    %w[linkable_type linkable_id].each do |attr|
      expect(link_response).to_not have_key(attr)
    end
  end
end