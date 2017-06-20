require 'rails_helper'

RSpec.describe Suggesters::Tags do
  describe '#suggest' do
    context 'with tags = ["ocean"]' do
      it 'returns all matching records', :worker, :elasticsearch do
        title = Faker::Hipster.sentence
        network = create(:network, name: title)
        create(:network, name: title)
        resource = create(:resource, title: title)

        network.tag_list.add('ocean')
        network.save

        resource.tag_list.add('ocean')
        resource.save

        wait_for { Suggesters::Tags.new(tags: ['ocean']).suggest.size }.to eq(2)
        records = Suggesters::Tags.new(tags: ['ocean']).suggest

        expect(records).to include(network)
        expect(records).to include(resource)
      end
    end

    context 'with tags = ["ocean"], except = network' do
      it 'returns all matching records except the specified network',
         :worker, :elasticsearch do
        title = Faker::Hipster.sentence
        network = create(:network, name: title)
        create(:network, name: title)
        resource = create(:resource, title: title)

        network.tag_list.add('ocean')
        network.save

        resource.tag_list.add('ocean')
        resource.save

        wait_for { Suggesters::Tags.new(tags: ['ocean']).suggest.size }.to eq(2)
        records = Suggesters::Tags.new(tags: ['ocean'], except: network).suggest

        expect(records).not_to include(network)
        expect(records).to include(resource)
      end
    end

    context 'with tags = ["ocean"], limit = 1' do
      it 'returns only one matching record', :worker, :elasticsearch do
        title = Faker::Hipster.sentence
        network = create(:network, name: title)
        create(:network, name: title)
        resource = create(:resource, title: title)

        network.tag_list.add('ocean')
        network.save

        resource.tag_list.add('ocean')
        resource.save

        wait_for { Suggesters::Tags.new(tags: ['ocean']).suggest.size }.to eq(2)
        records = Suggesters::Tags.new(tags: ['ocean'], limit: 1).suggest

        expect(records.count).to eq 1
      end
    end

    context 'with tags = ["ocean"], models = [Network]' do
      it 'returns only Network records', :worker, :elasticsearch do
        title = Faker::Hipster.sentence
        network = create(:network, name: title)
        create(:network, name: title)
        resource = create(:resource, title: title)

        network.tag_list.add('ocean')
        network.save

        resource.tag_list.add('ocean')
        resource.save

        wait_for { Suggesters::Tags.new(tags: ['ocean']).suggest.size }.to eq(2)
        records = Suggesters::Tags.new(tags: ['ocean'], models: [Network]).suggest

        expect(records).to include(network)
        expect(records).not_to include(resource)
      end
    end
  end
end
