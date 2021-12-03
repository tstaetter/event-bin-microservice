# frozen_string_literal: true

require 'spec_helper'

describe SchemaStore::RedisStore do
  let :store do
    described_class.new
  end

  let :schema do
    JSON.load_file 'spec/fixtures/schemas/default.schema.json'
  end

  # Set sample schema
  before do
    Redis.new.set "#{described_class::SCHEMA_KEY_PREFIX}default", schema.to_json
  end

  # Cleanup
  after do
    Redis.new.del "#{described_class::SCHEMA_KEY_PREFIX}default"
  end

  context 'when retrieving the definition' do
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
