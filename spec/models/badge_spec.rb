require 'rails_helper'

RSpec.describe Badge, type: :model do
  it { should belong_to :question }

  it { should have_many(:users_badges).dependent(:destroy) }
  it { should have_many(:users).through(:users_badges) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :image }
  it { subject.validates_with attributes: ContentTypeValidator }

  it 'has attached image' do
    expect(Badge.new.image).to be_an_instance_of ActiveStorage::Attached::One
  end
end
