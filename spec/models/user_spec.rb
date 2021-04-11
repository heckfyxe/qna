require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).with_foreign_key('author_id').dependent(:nullify) }
  it { should have_many(:answers).with_foreign_key('author_id').dependent(:nullify) }

  it { should have_many(:users_badges).dependent(:destroy) }
  it { should have_many(:badges).through(:users_badges) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:user) { create(:user) }
  let(:author_question) { create(:question, author: user) }

  let(:question) { create(:question) }
end
