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
end
