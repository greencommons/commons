require 'rails_helper'

RSpec.describe UserFilter do
  let(:group) { create(:group) }
  let(:john) { create(:user, email: 'john@commons.org') }
  let(:mark) { create(:user, email: 'mark@commons.org') }
  let(:jack) { create(:user, email: 'jack@commons.org') }

  describe '#run' do
    context 'when group_id is given to scope down the results' do
      context 'when query = comm' do

        context 'when the group contains users' do
          it 'returns all the users not belonging to the given group' do
            group.add_user(john)
            mark && jack

            users = UserFilter.new(query: 'comm', group_id: group.id).run
            expect(users.map(&:email)).not_to include('john@commons.org')
            expect(users.map(&:email)).to include('mark@commons.org',
                                                  'jack@commons.org')
          end
        end

        context 'when the group has no users' do
          it 'returns all the users' do
            john && mark && jack

            users = UserFilter.new(query: 'comm', group_id: group.id).run
            expect(users.map(&:email)).to include('john@commons.org',
                                                  'mark@commons.org',
                                                  'jack@commons.org')
          end
        end
      end

      context 'when query = jo' do
        it 'returns nothing' do
          group.add_user(john)
          mark && jack

          users = UserFilter.new(query: 'jo', group_id: group.id).run
          expect(users).to eq([])
        end
      end
    end

    context 'when group_id is nil' do
      context 'when query = comm' do
        it 'returns all the users' do
          john && mark && jack

          users = UserFilter.new(query: 'comm').run
          expect(users.map(&:email)).to include('john@commons.org',
                                                'mark@commons.org',
                                                'jack@commons.org')
        end
      end

      context 'when query = jo' do
        it 'returns john' do
          john && mark && jack

          users = UserFilter.new(query: 'jo').run
          expect(users.map(&:email)).to eq(['john@commons.org'])
        end
      end
    end
  end
end
