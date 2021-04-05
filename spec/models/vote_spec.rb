require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to(:votable) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:votable) }
  it { should validate_numericality_of(:value).only_integer }
  it { should validate_inclusion_of(:value).in_range(-1..1) }
end
