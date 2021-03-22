require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, :with_attachment, author: user) }

  describe 'DELETE #destroy' do
    context 'Author' do
      before { sign_in(user) }

      it 'deletes files' do
        expect {
          delete :destroy, params: { id: question.files.first.id }, format: :js
        }.to change(question.files, :count).by -1
      end
    end

    context 'No author' do
      it 'cannot delete files' do
        expect {
          delete :destroy, params: { id: question.files.first.id }, format: :js
        }.to_not change(question.files, :count)
      end
    end
  end
end
