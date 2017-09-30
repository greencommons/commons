require 'rails_helper'

RSpec.describe Resource do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      resource = build(:resource)

      expect(resource).to be_valid
    end

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:resource_type) }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:lists_items) }
    it { is_expected.to have_many(:lists) }
  end

  describe 'Callbacks' do
    describe 'after_commit' do
      let(:resource) do
        create(:resource, user_input: user_input, content_download_link: file_url)
      end
      let(:file_url) { nil }

      before do
        stub_const('ProcessResourceFileJob', Class.new(ProcessResourceFileJob))
        allow(ProcessResourceFileJob).to receive(:perform_async)
        resource.run_callbacks(:commit)
      end
      describe '#enqueue_process_uploaded_file' do
        context 'when the user provides the resource data' do
          let(:user_input) { true }

          context 'when the content_download_link is provided' do # rubocop:disable RSpec/NestedGroups
            let(:file_url) { '/path/to/file.pdf' }

            it 'enqueues a job for proccess a file' do
              expect(ProcessResourceFileJob).to have_received(:perform_async).
                with(resource.id)
            end
          end
          context 'when the content_download_link is not provided' do # rubocop:disable RSpec/NestedGroups
            let(:file_url) { nil }

            it 'does not enqueue a job for proccess a file' do
              expect(ProcessResourceFileJob).not_to have_received(:perform_async)
            end
          end
        end
        context 'when the resource data is not provided by a user' do
          let(:user_input) { false }
          
          it 'does not enqueue a job for proccess a file' do
            expect(ProcessResourceFileJob).not_to have_received(:perform_async)
          end
        end
      end
    end
  end

  it_behaves_like 'indexable', :resource
  it_behaves_like 'privacy', :resource

  Resource::METADATA_FIELDS.each do |field|
    let(:resource) { build(:resource) }
    let(:value) { 'value' }

    describe "#{field}=" do
      it "should assign the value to #{field} metadata field" do
        resource.send("#{field}=", value)
        expect(resource.metadata[field]).to eq(value)
      end
    end

    describe field do
      let(:resource) { build(:resource) }
      let(:value) { 'value' }

      it "should return the value of #{field} metadata field" do
        resource.metadata[field] = value
        expect(resource.send(field)).to eq(value)
      end
    end
  end
end
