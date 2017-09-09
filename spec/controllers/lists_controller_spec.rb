require 'rails_helper'

RSpec.describe ListsController, type: :controller do
  let(:current_user) { create(:user) }

  describe 'GET #new' do
    def do_request(params = {})
      get :new, params: { model_name: 'List' }.merge(params)
    end

    context 'when the user is not authenticated' do
      before do
        do_request
      end

      it_behaves_like 'the user is not authenticated'
    end

    context 'when the user is authenticated' do
      let(:params) { {} }

      before do
        sign_in(current_user)
        do_request(params)
      end

      it 'is success' do
        expect(response).to be_success
      end

      it 'assigns a new list' do
        expect(assigns(:list).is_a?(List)).to eq(true)
        expect(assigns(:list)).to be_new_record
      end

      context 'when the owner is provided' do
        let(:network) { create(:network) }
        let(:params) { { list: { owner: "Network:#{network.id}" } } }

        it 'assigns the owner to the list' do
          expect(assigns(:list).owner).to eq(network)
        end
      end
    end
  end
end
