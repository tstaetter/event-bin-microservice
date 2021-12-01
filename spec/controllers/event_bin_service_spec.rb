# frozen_string_literal: true

require 'spec_helper'
require 'rack/test'

describe EventBinService do
  include Rack::Test::Methods

  let :app do
    EventBinService
  end

  let :payload do
    File.read 'spec/fixtures/event.json'
  end

  context 'when POST /receive' do
    it 'returns status 202 ACCEPTED' do
      post '/receive', payload, EventBin::EventBin::TENANT_HEADER => 'default'

      expect(last_response.status).to eq EventBinService::RESPONSE_CODES[:ok]
    end

    it 'returns status 400 BAD REQUEST' do
      post '/receive', nil, EventBin::EventBin::TENANT_HEADER => 'default'

      expect(last_response.status).to eq EventBinService::RESPONSE_CODES[:invalid]
    end

    it 'returns status 422 UNPROCESSABLE ENTITY' do
      post '/receive'

      expect(last_response.status).to eq EventBinService::RESPONSE_CODES[:no_schema]
    end

    pending 'returns status 500 INTERNAL SERVER ERROR'
  end
end
