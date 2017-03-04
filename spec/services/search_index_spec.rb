# frozen_string_literal: true
require "rails_helper"

RSpec.describe SearchIndex do
  describe ".index_name" do
    it "returns the correct index name, given the model and environment" do
      name = SearchIndex.index_name(Resource)

      expect(name).to eq "resources-test"
    end
  end

  describe ".log_elasticsearch_warning" do
    it "logs a warning, tagged with [elasticsearch]" do
      allow(Rails.logger).to receive(:tagged)

      SearchIndex.log_elasticsearch_warning("watch out!")

      expect(Rails.logger).to have_received(:tagged).with("ELASTICSEARCH")
    end
  end

  describe "#add" do
    it "adds the record to the search index" do
      travel_to(Time.zone.now) do
        allow(Elasticsearch::Model.client).to receive(:index)
        record = create(:resource)
        model_name = record.class.name

        SearchIndex.new(model_name: model_name, id: record.id).add

        expect(Elasticsearch::Model.client).to have_received(:index).
          with(
            index: model_name.constantize.index_name,
            type: model_name.downcase,
            id: record.id,
            body: record.__elasticsearch__.as_indexed_json,
          )
      end
    end

    context "if callbacks are disabled", search_indexing_callbacks: false do
      it "does not enqueue the job" do
        allow(Elasticsearch::Model.client).to receive(:index)
        record = create(:resource)
        model_name = record.class.name

        SearchIndex.new(model_name: model_name, id: record.id).add

        expect(Elasticsearch::Model.client).not_to have_received(:index)
      end

      it "logs a warning" do
        record = create(:resource)
        model_name = record.class.name
        allow(Rails.logger).to receive(:warn)

        SearchIndex.new(model_name: model_name, id: record.id).add

        expect(Rails.logger).to have_received(:warn).
          with(/callbacks.+disabled/)
      end
    end
  end

  describe "#update" do
    it "updates the record in the search index" do
      travel_to(Time.zone.now) do
        allow(Elasticsearch::Model.client).to receive(:update)
        record = create(:resource)
        model_name = record.class.name
        SearchIndex.new(model_name: model_name, id: record.id).add

        title = Faker::Book.title
        record.update(title: title)
        SearchIndex.new(model_name: model_name, id: record.id, changed: ["title"]).update

        expect(Elasticsearch::Model.client).to have_received(:update).
          with(
            index: model_name.constantize.index_name,
            type: model_name.downcase,
            id: record.id,
            body: { doc: { "title" => title } },
          )
      end
    end

    context "when the record is not indexed properly" do
      it "raises Elasticsearch::Transport::Transport::Errors::NotFound" do
        travel_to(Time.zone.now) do
          allow(Elasticsearch::Model.client).to receive(:index)

          record = create(:resource)
          model_name = record.class.name

          SearchIndex.new(model_name: model_name, id: record.id).remove

          title = Faker::Book.title
          record.update(title: title)
          expect do
            SearchIndex.new(model_name: model_name, id: record.id, changed: ["title"]).update
          end.not_to raise_error

          expect(Elasticsearch::Model.client).to have_received(:index)
        end
      end
    end

    context "if callbacks are disabled", search_indexing_callbacks: false do
      it "does not enqueue the job" do
        allow(Elasticsearch::Model.client).to receive(:update)
        record = create(:resource)
        model_name = record.class.name

        title = Faker::Book.title
        record.update(title: title)
        SearchIndex.new(model_name: model_name, id: record.id, changed: ["title"]).update

        expect(Elasticsearch::Model.client).not_to have_received(:update)
      end

      it "logs a warning" do
        record = create(:resource)
        model_name = record.class.name
        allow(Rails.logger).to receive(:warn)

        title = Faker::Book.title
        record.update(title: title)
        SearchIndex.new(model_name: model_name, id: record.id, changed: ["title"]).update

        expect(Rails.logger).to have_received(:warn).
          with(/callbacks.+disabled/)
      end
    end
  end

  describe "#remove" do
    it "removes the record from the index" do
      record = create(:resource)
      model_name = record.class.name
      allow(Elasticsearch::Model.client).to receive(:delete)

      SearchIndex.new(model_name: model_name, id: record.id).remove

      expect(Elasticsearch::Model.client).to have_received(:delete).
        with(
          index: model_name.constantize.index_name,
          type: model_name.downcase,
          id: record.id,
        )
    end

    context "when the record is not indexed properly" do
      it "raises Elasticsearch::Transport::Transport::Errors::NotFound" do
        travel_to(Time.zone.now) do
          record = create(:resource)
          model_name = record.class.name
          SearchIndex.new(model_name: model_name, id: record.id).remove

          expect do
            SearchIndex.new(model_name: model_name, id: record.id).remove
          end.not_to raise_error
        end
      end
    end

    context "if callbacks are disabled", search_indexing_callbacks: false do
      it "does not enqueue the job" do
        allow(Elasticsearch::Model.client).to receive(:delete)
        record = create(:resource)
        model_name = record.class.name

        SearchIndex.new(model_name: model_name, id: record.id).remove

        expect(Elasticsearch::Model.client).not_to have_received(:delete)
      end

      it "logs a warning" do
        record = create(:resource)
        model_name = record.class.name
        allow(Rails.logger).to receive(:warn)

        SearchIndex.new(model_name: model_name, id: record.id).remove

        expect(Rails.logger).to have_received(:warn).
          with(/callbacks.+disabled/)
      end
    end
  end
end
