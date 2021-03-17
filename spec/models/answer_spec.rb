require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to(:author).class_name('User').with_foreign_key('author_id') }

  it { should validate_presence_of :body }
  it 'validates one the best answer for question' do
    question = create(:question)
    answers = create_list(:answer, 2, :the_best, question: question)
    answer = answers.first
    answer.validate
    expect(answer.errors[:base]).to eq ['Question can have only one the best answer']
  end
end
