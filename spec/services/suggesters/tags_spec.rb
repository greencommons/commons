require 'rails_helper'

RSpec.describe Suggesters::Tags do
  describe '#suggest' do
    context 'with tags = ["ocean"]' do
      it 'returns all matching records', elasticsearch: true, sidekiq: true do
        title = Faker::Hipster.sentence
        group = create(:group, name: title)
        create(:group, name: title)
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

    context 'with tags = ["ocean"], except = group' do
      it 'returns all matching records except the specified group',
         elasticsearch: true, sidekiq: true do
        title = Faker::Hipster.sentence
        group = create(:group, name: title)
        create(:group, name: title)
        resource = create(:resource, title: title)

        group.tag_list.add('ocean')
        group.save

        resource.tag_list.add('ocean')
        resource.save

        wait_for { Suggesters::Tags.new(tags: ['ocean']).suggest.size }.to eq(2)
        records = Suggesters::Tags.new(tags: ['ocean'], except: group).suggest

        expect(records).not_to include(group)
        expect(records).to include(resource)
      end
    end

    context 'with tags = ["ocean"], limit = 1' do
      it 'returns only one matching record', elasticsearch: true, sidekiq: true do
        title = Faker::Hipster.sentence
        group = create(:group, name: title)
        create(:group, name: title)
        resource = create(:resource, title: title)

        group.tag_list.add('ocean')
        group.save

        resource.tag_list.add('ocean')
        resource.save

        wait_for { Suggesters::Tags.new(tags: ['ocean']).suggest.size }.to eq(2)
        records = Suggesters::Tags.new(tags: ['ocean'], limit: 1).suggest

        expect(records).to include(group)
        expect(records).not_to include(resource)
      end
    end

    context 'with tags = ["ocean"], models = [Group]' do
      it 'returns only Group records', elasticsearch: true, sidekiq: true do
        title = Faker::Hipster.sentence
        group = create(:group, name: title)
        create(:group, name: title)
        resource = create(:resource, title: title)

        group.tag_list.add('ocean')
        group.save

        resource.tag_list.add('ocean')
        resource.save

        wait_for { Suggesters::Tags.new(tags: ['ocean']).suggest.size }.to eq(2)
        records = Suggesters::Tags.new(tags: ['ocean'], models: [Group]).suggest

        expect(records).to include(group)
        expect(records).not_to include(resource)
      end
    end
  end
end
