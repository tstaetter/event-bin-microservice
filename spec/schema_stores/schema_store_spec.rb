# frozen_string_literal: true

require 'spec_helper'

describe SchemaStore do
  context 'when loading a store' do
    it 'returns a FileStore' do
      expect(SchemaStore.load).to be_a SchemaStore::FileStore
    end
  end
end
