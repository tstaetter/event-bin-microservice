# frozen_string_literal: true

require 'spec_helper'

describe SchemaStore do
  context 'when trying to load some store' do
    before do
      allow(ENV).to receive(:[]).with('REDIS_URL').and_return(nil)
      allow(ENV).to receive(:[]).with('SCHEMAS_PATH').and_return(nil)
    end

    it 'raises ArgumentError if no needed env vars are defined' do
      expect do
        described_class.load
      end.to raise_error ArgumentError
    end
  end

  context 'when loading a FileStore' do
    before do
      allow(ENV).to receive(:[]).with('REDIS_URL').and_return(nil)
      allow(ENV).to receive(:[]).with('SCHEMAS_PATH').and_return('schemas')
    end

    it 'returns a FileStore, if appropriate' do
      expect(described_class.load).to be_a SchemaStore::FileStore
    end
  end

  context 'when loading a RedisStore' do
    before do
      allow(ENV).to receive(:[]).with('REDIS_URL').and_return('redis://127.0.0.1:6379/1')
      allow(ENV).to receive(:[]).with('SCHEMAS_PATH').and_return(nil)
    end

    it 'returns a RedisStore, if appropriate' do
      expect(described_class.load).to be_a SchemaStore::RedisStore
    end

    it 'raises error if no valid URL is specified' do
      allow(ENV).to receive(:[]).with('REDIS_URL').and_return('not-valid')

      expect do
        described_class.load
      end.to raise_error ArgumentError
    end
  end
end
