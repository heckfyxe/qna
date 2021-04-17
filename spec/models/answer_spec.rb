require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it_behaves_like 'has author model'
  it_behaves_like 'linkable model'
  it_behaves_like 'commentable model'

  it { should validate_presence_of :body }
  it 'validates one the best answer for question' do
    question = create(:question)
    answers = create_list(:answer, 2, :the_best, question: question)
    answer = answers.first
    answer.validate
    expect(answer.errors[:base]).to eq ['Question can have only one the best answer']
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of ActiveStorage::Attached::Many
  end

  context 'votes' do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:model) { create(:answer, author: author) }

    it_behaves_like 'votable model'
  end

  context 'subscribers' do
    let(:answer) { build(:answer) }

    it 'notifies subscribers' do
      expect(NotifySubscribersJob).to receive(:perform_later).with(answer.question)
      answer.save!
    end
  end
end
