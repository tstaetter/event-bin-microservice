# frozen_string_literal: true

require 'spec_helper'

describe EventQueue::Event do
  let :origin do
    JSON.load_file 'spec/fixtures/event.json'
  end

  let :event do
    described_class.new origin, 'default'
  end

  context 'when initialized' do
    it 'has metadata set' do
      expect(event.instance_variable_get(:'@_meta')).to be_a Hash
    end

    it 'has an ID set' do
      expect(event.instance_variable_get(:'@_meta')[:_id]).to match UUID_REGEX
    end

    it 'has a tenant ID set' do
      expect(event.instance_variable_get(:'@_meta')[:_tenant_id]).to_not be_empty
    end

    it 'has the payload set to given origin event' do
      expect(event.instance_variable_get(:'@_origin')).to eq origin
    end
  end

  context 'when serializing to JSON' do
    it 'returns a valid JSON representation' do
      expect do
        JSON.parse event.to_json
      end.to_not raise_error
    end

    it 'has hash value set' do
      expect(JSON.parse(event.to_json)['_hash'].length).to eq 64
    end
  end
end
