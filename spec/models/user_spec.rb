require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).with_foreign_key('author_id').dependent(:nullify) }
  it { should have_many(:answers).with_foreign_key('author_id').dependent(:nullify) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:author_question) { create(:question) }
  let(:author_answer) { create(:answer) }
  let(:user) { create(:user, questions: [author_question], answers: [author_answer]) }

  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe '#author?' do
    it("returns true for user's question") { expect(user.author?(author_answer)).to be_truthy }
    it("return true for user's answer") { expect(user.author?(author_question)).to be_truthy }

    it("returns false for no user's question") { expect(user.author?(answer)).to be_falsey }
    it("returns false for no user's answer") { expect(user.author?(answer)).to be_falsey }
  end
end
