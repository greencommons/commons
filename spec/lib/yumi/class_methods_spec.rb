require 'spec_helper'

describe Yumi::ClassMethods do
  FAKE_META_DATA = { some: 'stuff' }.freeze
  let(:url) { BASE_URL }

  module Fake
    class PostPresenter < ::Yumi::Base
      attributes :one, :two, :three
      has_many :things, :cars
      belongs_to :owner
      links :self
    end
  end

  describe '.attributes' do
    it 'assigns the attributes value to the class instance _attributes' do
      expect(Fake::PostPresenter._attributes).to eq([:one, :two, :three])
    end

    it 'adds the attributes value in the options hash for a new instance' do
      presenter = Fake::PostPresenter.new(url, [])
      expect(presenter.attributes).to eq([:one, :two, :three])
    end
  end

  describe '.has_many / .belongs_to' do
    it 'assigns the relationships value to the class instance _relationships' do
      expect(Fake::PostPresenter._relationships).to eq([:things, :cars, :owner])
    end

    it 'adds the relationships value in the options hash for a new instance' do
      presenter = Fake::PostPresenter.new(url, [])
      expect(presenter.relationships).to eq([:things, :cars, :owner])
    end
  end

  describe '.links' do
    it 'assigns the links value to the class instance _links' do
      expect(Fake::PostPresenter._links).to eq([:self])
    end

    it 'adds the links value in the options hash for a new instance' do
      presenter = Fake::PostPresenter.new(url, [])
      expect(presenter.links).to eq([:self])
    end
  end
end
