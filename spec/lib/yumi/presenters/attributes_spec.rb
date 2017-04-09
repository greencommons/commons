# spec/yumi/presenters/attributes_spec.rb
require 'spec_helper'

describe Yumi::Presenters::Attributes do
  let(:attributes) { [:description, :slug] }
  let(:resource) { double(:_resource, description: "I'm a resource.", slug: 'whatever') }
  let(:presenter) { double(:_presenter, resource: resource, attributes: attributes, fields: nil) }

  let(:klass) { Yumi::Presenters::Attributes.new(presenter) }

  describe '#to_json_api' do
    context 'without overrides' do
      it 'generates the hash only with the resource attributes' do
        expect(klass.to_json_api).to eq(description: "I'm a resource.",
                                        slug: 'whatever')
      end
    end

    context 'with overrides' do
      let(:presenter) do
        double(:_presenter, resource: resource,
                            attributes: attributes,
                            fields: nil,
                            description: "I'm a presenter.")
      end

      it 'outputs the hash with the description overridden' do
        expect(klass.to_json_api).to eq(description: "I'm a presenter.",
                                        slug: 'whatever')
      end
    end

    context 'with fields picking' do
      let(:presenter) do
        double(:_presenter, resource: resource,
                            attributes: attributes,
                            type: 'resource',
                            fields: { 'resources' => 'slug' },
                            description: "I'm a presenter.")
      end

      it 'outputs the hash with only the slug' do
        expect(klass.to_json_api).to eq(slug: 'whatever')
      end
    end
  end
end
