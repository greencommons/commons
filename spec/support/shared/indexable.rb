RSpec.shared_examples 'indexable' do |name|
  describe 'Callbacks' do
    describe 'after_save' do
      it "adds the #{name} to the search index after creation" do
        allow(AddToIndexJob).to receive(:perform_async)

        record = create(name)

        expect(AddToIndexJob).to have_received(:perform_async).
          with(record.class.name, record.id)
      end
    end

    describe 'after_destroy' do
      it "removes the #{name} from the search index after deletion" do
        record = create(name)
        allow(RemoveFromIndexJob).to receive(:perform_async)

        record.destroy

        expect(RemoveFromIndexJob).to have_received(:perform_async).
          with(record.class.name, record.id)
      end
    end
  end
end
