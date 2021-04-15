shared_examples_for 'comments field' do
  it 'returns list of comments' do
    expect(comments_response.size).to eq comments.size
  end

  it 'returns all public fields' do
    %w[id body created_at updated_at].each do |attr|
      expect(comment_response[attr]).to eq comment.send(attr).as_json
    end
  end

  it "doesn't returns all private fields" do
    %w[commentable_type commentable_id].each do |attr|
      expect(comment_response).to_not have_key(attr)
    end
  end

  it_behaves_like 'user field' do
    let(:user) { comment.author }
    let(:user_response) { comment_response['author'] }
  end
end