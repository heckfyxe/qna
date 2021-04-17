require 'rails_helper'

RSpec.describe NotifySubscribersJob, type: :job do
  let(:service) { double('NotifySubscribersService') }
  let(:question) { build(:question) }

  before do
    allow(NotifySubscribersService).to receive(:new).and_return(service)
  end

  it 'calls NotifySubscribersService#notify' do
    expect(service).to receive(:notify).with(question)
    NotifySubscribersJob.perform_now(question)
  end
end
