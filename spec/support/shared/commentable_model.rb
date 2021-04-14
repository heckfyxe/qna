shared_examples_for 'commentable model' do
  it { should has_many(:comments).dependent(:destroy) }
end
