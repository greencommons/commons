RSpec.shared_examples 'privacy' do |name|
  describe 'privacy' do
    let(:target) { create(name, privacy: :priv) }

    describe 'after_commit on: [:create]' do
      it "does not add the #{name} to the search index after creation" do
        allow(AddToIndexJob).to receive(:perform_async)

        expect(AddToIndexJob).not_to have_received(:perform_async).
          with(target.class.name, target.id)
      end
    end

    describe 'after_commit on: [:update]' do
      it "does not update the #{name} index in the search index after update" do
        allow(UpdateIndexJob).to receive(:perform_async)

        target.touch

        expect(UpdateIndexJob).not_to have_received(:perform_async).
          with(target.class.name, target.id, [])
      end
    end

    describe 'after_commit on: [:destroy]' do
      it "does not remove the #{name} from the search index after deletion" do
        allow(RemoveFromIndexJob).to receive(:perform_async)

        target.destroy

        expect(RemoveFromIndexJob).not_to have_received(:perform_async).
          with(target.class.name, target.id)
      end
    end
  end
end
