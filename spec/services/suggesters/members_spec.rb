require 'rails_helper'

RSpec.describe Suggesters::Members do
  describe '#run' do
    context 'when network_id is given to scope down the results' do
      context 'when the network contains users' do
        it 'returns all the users not belonging to the given network' do
          network = create(:network)
          john = create(:user, email: 'john@commons.org')
          create(:user, email: 'mark@commons.org')
          create(:user, email: 'jack@commons.org')

          network.add_user(john)

          users = Suggesters::Members.new(query: 'comm', network_id: network.id).suggest
          expect(users.map(&:email)).not_to include('john@commons.org')
          expect(users.map(&:email)).to include('mark@commons.org',
                                                'jack@commons.org')
        end

        it 'returns no users when the only matching user belongs to the network' do
          network = create(:network)
          john = create(:user, email: 'john@commons.org')
          create(:user, email: 'mark@commons.org')
          create(:user, email: 'jack@commons.org')

          network.add_user(john)

          users = Suggesters::Members.new(query: 'jo', network_id: network.id).suggest
          expect(users).to eq([])
        end
      end

      context 'when the network has no users' do
        it 'returns all the users with query=comm' do
          network = create(:network)
          create(:user, email: 'john@commons.org')
          create(:user, email: 'mark@commons.org')
          create(:user, email: 'jack@commons.org')

          users = Suggesters::Members.new(query: 'comm', network_id: network.id).suggest
          expect(users.map(&:email)).to include('john@commons.org',
                                                'mark@commons.org',
                                                'jack@commons.org')
        end
      end
    end

    context 'when network_id is nil' do
      it 'returns all the users with query=comm' do
        create(:user, email: 'john@commons.org')
        create(:user, email: 'mark@commons.org')
        create(:user, email: 'jack@commons.org')

        users = Suggesters::Members.new(query: 'comm').suggest
        expect(users.map(&:email)).to include('john@commons.org',
                                              'mark@commons.org',
                                              'jack@commons.org')
      end

      it 'returns john with query=jo' do
        create(:user, email: 'john@commons.org')
        create(:user, email: 'mark@commons.org')
        create(:user, email: 'jack@commons.org')

        users = Suggesters::Members.new(query: 'jo').suggest
        expect(users.map(&:email)).to eq(['john@commons.org'])
      end
    end
  end
end
