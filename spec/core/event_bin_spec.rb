# frozen_string_literal: true

require 'spec_helper'
require 'rack/mock'
require 'securerandom'

describe EventBin::EventBin do
  shared_examples_for 'EventBin' do
    context 'when initialized with valid params' do
      let :bin do
        described_class.new 'default', payload
      end

      it 'can retrieve tenant ID' do
        expect(bin.send(:tenant)).to eq 'default'
      end

      it 'can retrieve JSON payload' do
        expect(bin.send(:payload)).to eq File.read('spec/fixtures/event.json')
      end

      it 'can validate the event' do
        expect(bin.run.status).to eq EventBin::RunResult::Codes::OK
      end
    end

    context 'when initialized with unknown tenant' do
      let :tenant do
        SecureRandom.alphanumeric 10
      end

      let :bin do
        described_class.new tenant, payload
      end

      it 'returns NO_SCHEMA for unknown tenant' do
        expect(bin.run.status).to eq EventBin::RunResult::Codes::NO_SCHEMA
      end
    end

    context 'when initialized with invalid payload' do
      let :payload do
        { foo: :bar }.to_json
      end

      let :bin do
        described_class.new 'default', payload
      end

      it 'returns invalid for invalid payload' do
        expect(bin.run.status).to eq EventBin::RunResult::Codes::INVALID
      end
    end

    context 'when determining the error result' do
      it 'returns NO_SCHEMA for unknown schema' do
        result_status = EventBin::RunResult.error_result(Nanites::ValueError.new).status
        expect(result_status).to eq EventBin::RunResult::Codes::NO_SCHEMA
      end

      it 'returns INVALID for erroneous payload' do
        error = JSON::Schema::ValidationError.new '', '', '',
                                                  OpenStruct.new(uri: 'https://localhost')
        result_status = EventBin::RunResult.error_result(error).status
        expect(result_status).to eq EventBin::RunResult::Codes::INVALID
      end

      it 'returns UNKNOWN as fallback' do
        result_status = EventBin::RunResult.error_result(StandardError.new).status
        expect(result_status).to eq EventBin::RunResult::Codes::UNKNOWN
      end
    end
  end

  let :payload do
    File.read('spec/fixtures/event.json')
  end

  context 'when using FileStore' do
    include_context 'FileStore'

    it_behaves_like 'EventBin'
  end

  context 'when using RedisStore' do
    include_context 'RedisStore'

    it_behaves_like 'EventBin'
  end
end
