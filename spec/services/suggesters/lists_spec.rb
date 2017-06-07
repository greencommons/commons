require 'rails_helper'

RSpec.describe Suggesters::Lists do
  describe '#suggest', :worker, :elasticsearch do
    let(:list1) { create(:list, name: 'test 1') }
    let(:list2) { create(:list, name: 'test 2') }
    let(:list3) { create(:list, name: 'test 3') }
    let(:list4) { create(:list, name: 'something else') }

    before do
      list1 && list2 && list3 && list4
      wait_for { Suggesters::Lists.new(query: 'test').suggest.size }.to eq(3)
    end

    context 'without the only parameter' do
      it 'only returns all the matching lists' do
        lists = Suggesters::Lists.new(query: 'test').suggest
        expect(lists).to eq [
          { id: list1.id, name: 'test 1' },
          { id: list2.id, name: 'test 2' },
          { id: list3.id, name: 'test 3' }
        ]
      end
    end

    context 'with the only parameter' do
      it 'only returns the first list' do
        lists = Suggesters::Lists.new(query: 'test', only: [list1]).suggest
        expect(lists).to eq [{ id: list1.id, name: 'test 1' }]
      end
    end
  end
end
