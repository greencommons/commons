require 'rails_helper'

RSpec.describe Suggesters::Tags do
  describe '#suggest' do
    context 'with tags = ["ocean"]' do

      it 'returns ', elasticsearch: true, sidekiq: true do
        title = Faker::Hipster.sentence
        group = create(:group, name: title)
        group2 = create(:group, name: title)
        resource = create(:resource, title: title)

        group.tag_list.add('ocean')
        group.save

        resource.tag_list.add('ocean')
        resource.save

        wait_for { Suggesters::Tags.new(tags: ['ocean']).suggest.size }.to eq(2)
        records = Suggesters::Tags.new(tags: ['ocean']).suggest

        expect(records).to include(group)
        expect(records).to include(resource)
      end
    end
  end
end
