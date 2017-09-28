require 'rails_helper'

RSpec.describe LinkHelper, type: :helper do
  include LinkHelper

  describe '#link_to_back' do
    let(:title) { 'Link Title' }
    let(:result) { link_to_back(title) }
    let(:request) { double('request') }
    let(:env) { { 'HTTP_REFERER' => http_referrer } }
    let(:http_referrer) { nil }
    let(:host) { 'greencommons' }

    before do
      allow(request).to receive(:env).and_return(env)
      allow(request).to receive(:host).and_return(host)
    end

    context 'when the referrer is present' do
      context 'when the referrer includes the host' do
        context 'when the referrer is not a form page' do
          let(:http_referrer) { host }

          it 'returns a link to root path' do
            expect(result).to eq('<a href="javascript:history.back()">Link Title</a>')
          end
        end
        context 'when the referrer is a form page' do
          let(:http_referrer) { "#{host}/new" }

          it 'returns a link to root path' do
            expect(result).to eq('<a href="http://test.host/">Link Title</a>')
          end
        end
      end
      context 'when the referrer do not includes the host' do
        let(:http_referrer) { 'different_site' }

        it 'returns a link to root path' do
          expect(result).to eq('<a href="http://test.host/">Link Title</a>')
        end
      end
    end

    context 'when the referrer is not present' do
      it 'returns a link to root path' do
        expect(result).to eq('<a href="http://test.host/">Link Title</a>')
      end
    end
  end
end
