RSpec.shared_examples 'indexable' do |name|
  describe '#set_published_at' do
    context 'when published_at already present' do
      it 'does nothing' do
        date = Time.now
        record = create(name, published_at: date)
        expect(record.published_at.utc.to_s).to eq date.utc.to_s
      end
    end

    context 'when date in metadata' do
      it 'set the published_at' do
        date = Time.now
        record = build(name)

        if record.respond_to?(:metadata)
          record.metadata = { date: date }
          record.save!
          expect(record.published_at.to_date.to_s).to eq date.to_date.to_s
        end
      end

      context 'when date string' do
        it 'set the published_at' do
          date = Date.today
          record = build(name)

          if record.respond_to?(:metadata)
            record.metadata = { date: date }
            record.save!
            expect(record.published_at.to_date.to_s).to eq record.created_at.to_date.to_s
          end
        end
      end

      context 'when invalid' do
        it 'set the published_at' do
          date = 'fake date'
          record = build(name)

          if record.respond_to?(:metadata)
            record.metadata = { date: date }
            record.save
            expect(record.published_at).to eq record.created_at
          end
        end
      end
    end

    context 'when date not in metadata' do
      it 'set the published_at with created_at' do
        record = create(name)
        expect(record.published_at).to eq record.created_at
      end
    end
  end

  describe 'Callbacks' do
    describe 'after_create' do
      it 'calls "set_published_at"' do
        record = build(name)
        allow(record).to receive(:set_published_at)
        record.save
        expect(record).to have_received(:set_published_at)
      end
    end

    describe 'after_commit on: [:create]' do
      it "adds the #{name} to the search index after creation" do
        allow(AddToIndexJob).to receive(:perform_async)

        record = create(name)

        expect(AddToIndexJob).to have_received(:perform_async).
          with(record.class.name, record.id)
      end
    end

    describe 'after_commit on: [:update]' do
      it "updates the #{name} index in the search index after update" do
        allow(UpdateIndexJob).to receive(:perform_async)

        record = create(name)
        record.touch

        expect(UpdateIndexJob).to have_received(:perform_async).
          with(record.class.name, record.id, [])
      end
    end

    describe 'after_commit on: [:destroy]' do
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
