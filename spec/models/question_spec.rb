require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:badge).dependent(:destroy) }
  it { should belong_to(:author).class_name('User').with_foreign_key('author_id') }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :badge }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of ActiveStorage::Attached::Many
  end

  describe '#vote_up' do
    let(:author) { create(:user) }
    let(:question) { create(:question, author: author) }
    let(:user) { create(:user) }

    it 'User votes' do
      expect { question.vote_up(user) }.to change(Vote, :count).by(1)
      expect(Vote.last.value).to eq 1
    end
  end

  describe '#vote_down' do
    let(:author) { create(:user) }
    let(:question) { create(:question, author: author) }
    let(:user) { create(:user) }

    it 'User votes' do
      expect { question.vote_down(user) }.to change(Vote, :count).by(1)
      expect(Vote.last.value).to eq -1
    end
  end

  describe '#rating' do
    let(:question) { create(:question) }
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }

    it 'show total votes' do
      question.vote_up(user)
      question.reload

      expect(question.rating).to eq 1

      question.vote_down(another_user)
      question.reload

      expect(question.rating).to eq 0

      question.vote_down(user)
      question.reload

      expect(question.rating).to eq -1
    end
  end

  describe '#user_vote' do
    let(:question) { create(:question) }
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }

    it "show user's vote" do
      question.vote_up(user)
      question.vote_up(another_user)
      question.reload
      expect(question.user_vote(user)).to eq 1
    end
  end
end
