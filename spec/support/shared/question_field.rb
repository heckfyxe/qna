shared_examples_for "question field" do
  it 'returns all public fields' do
    %w[id title body created_at updated_at].each do |attr|
      expect(question_response[attr]).to eq question.send(attr).as_json
    end
  end

  it 'contains short title' do
    expect(question_response['short_title']).to eq question.title.truncate(7)
  end
end
