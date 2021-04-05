require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to(:author).class_name('User').with_foreign_key('author_id') }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }
  it 'validates one the best answer for question' do
    question = create(:question)
    answers = create_list(:answer, 2, :the_best, question: question)
    answer = answers.first
    answer.validate
    expect(answer.errors[:base]).to eq ['Question can have only one the best answer']
  end

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of ActiveStorage::Attached::Many
  end

  it { should accept_nested_attributes_for :links }


  describe '#vote_up' do
    let(:author) { create(:user) }
    let(:answer) { create(:answer, author: author) }
    let(:user) { create(:user) }

    it 'Author cannot vote' do
      expect { answer.vote_up(author) }.to_not change(Vote, :count)
    end

    it 'No author votes' do
      expect { answer.vote_up(user) }.to change(Vote, :count).by(1)
    end
  end

  describe '#vote_down' do
    let(:author) { create(:user) }
    let(:answer) { create(:answer, author: author) }
    let(:user) { create(:user) }

    it 'Author cannot vote' do
      expect { answer.vote_down(author) }.to_not change(Vote, :count)
    end

    it 'No author votes' do
      expect { answer.vote_down(user) }.to change(Vote, :count).by(1)
    end
  end

  describe '#rating' do
    let(:answer) { create(:answer) }
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }

    it 'show total votes' do
      answer.vote_up(user)
      answer.vote_up(another_user)
      answer.reload
      expect(answer.rating).to eq 2
    end
  end

  describe '#user_vote' do
    let(:answer) { create(:answer) }
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }

    it "show user's vote" do
      answer.vote_up(user)
      answer.vote_up(another_user)
      answer.reload
      expect(answer.user_vote(user)).to eq 1
    end
  end
end
