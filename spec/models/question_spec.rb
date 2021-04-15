require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_one(:badge).dependent(:destroy) }
  it_behaves_like 'has author model'
  it_behaves_like 'linkable model'
  it_behaves_like 'commentable model'

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :badge }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of ActiveStorage::Attached::Many
  end

  context 'votes' do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:model) { create(:answer, author: author) }

    it_behaves_like 'votable model'
  end
end
