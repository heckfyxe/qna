require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let!(:link) { create(:link, linkable: question) }

  describe 'DELETE #destroy' do
    context 'Author' do
      before { sign_in(user) }

      it 'deletes link' do
        expect { delete :destroy, params: { id: link }, format: :js }.to change(Link, :count).by(-1)
      end
    end

    context 'No author' do
      it 'cannot delete link' do
        expect { expect { delete :destroy, params: { id: link }, format: :js }.to_not change(Link, :count) }
      end
    end
  end
end
