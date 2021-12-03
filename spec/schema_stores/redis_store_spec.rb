# frozen_string_literal: true

require 'spec_helper'

describe SchemaStore::RedisStore do
  let :store do
    described_class.new
  end

  context 'when retrieving the definition' do
    include_context 'RedisStore'

    it 'returns some' do
      expect(JSON.parse(store.definition('default').value)).to eq schema
    end

    it 'returns none for unknown ID' do
      expect(store.definition('foo-bar').none?).to be_truthy
    end

    it 'returns none for empty ID' do
      expect(store.definition('').none?).to be_truthy
    end
  end
end
