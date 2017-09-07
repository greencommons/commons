require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  describe 'GET #home' do
    def perform_request
      get :home
    end

    let(:counts) do
      { 0 => 20, 1 => 20, 3 => 20, 4 => 20 }
    end

    before do
      20.times do
        create(:network)
        create(:book)
        create(:article)
        create(:url)
        create(:audio)
      end
      perform_request
    end

    it 'responds with success' do
      expect(response).to be_success
    end

    it 'assigns 10 random networks' do
      expect(assigns(:networks).count).to eq(10)
    end

    it 'assigns resource count by resource type' do
      expect(assigns(:counts)).to eq(counts)
    end
  end
end
