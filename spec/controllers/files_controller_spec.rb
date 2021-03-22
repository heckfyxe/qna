require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let!(:question) { create(:question, :with_attachment) }

  describe 'DELETE #destroy' do
    it 'deletes files' do
      delete :destroy, params: { id: question.files.first.id }, format: :js
      question.reload

      expect(question.files.count).to be_zero
    end
  end
end
