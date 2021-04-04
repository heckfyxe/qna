require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to(:votable) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:votable) }
  it {
    should validate_numericality_of(:value).only_integer.is_less_than_or_equal_to(1).is_greater_than_or_equal_to(-1)
  }
end
