shared_examples_for 'linkable model' do
  it { should have_many(:links).dependent(:destroy) }
  it { should accept_nested_attributes_for :links }

end
