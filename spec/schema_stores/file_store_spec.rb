# frozen_string_literal: true

require 'spec_helper'

describe SchemaStore::FileStore do
  let :store do
    described_class.new
  end

  context 'when constructing the schema file name' do
    it 'returns some' do
      store.instance_variable_set :'@_base', 'spec/fixtures'
      target_path = File.absolute_path('default.schema.json', 'spec/fixtures')

      expect(store.send(:schema_file, 'default').value).to eq target_path
    end

    it 'returns none' do
      store.instance_variable_set :'@_base', 'foo/bar'

      expect(store.send(:schema_file, 'default').none?).to be_truthy
    end
  end

  context 'when retrieving the definition' do
    let :schema do
      JSON.load_file 'spec/fixtures/default.schema.json'
    end

    it 'returns some' do
      store.instance_variable_set :'@_base', 'spec/fixtures'

      expect(store.definition('default').value).to eq schema
    end

    it 'returns none' do
      store.instance_variable_set :'@_base', 'foo/bar'

      expect(store.definition('default').none?).to be_truthy
    end
  end
end
