shared_examples_for 'has author model' do
  it { should belong_to(:author).class_name('User').with_foreign_key('author_id') }
end
