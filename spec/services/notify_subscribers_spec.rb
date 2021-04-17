require 'rails_helper'

RSpec.describe NotifySubscribersService do
  let(:question) { create(:question) }

  it 'sends daily digest to all users' do
    expect(NotifySubscribersMailer).to receive(:notification).with(question.author, question).and_call_original
    subject.notify(question)
  end
end

