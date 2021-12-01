# frozen_string_literal: true

require 'spec_helper'

describe SchemaStore::BaseStore do
  let :store do
    described_class.new
  end

  context 'when retrieving the definition' do
    it 'raises error' do
      expect do
        store.definition('default').value
      end.to raise_error NotImplementedError
    end
  end
end
