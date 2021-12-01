# frozen_string_literal: true

require 'sinatra/base'

# Actual service class
class EventBinService < Sinatra::Application
  # Supported response codes
  RESPONSE_CODES = {
    ok: 202,
    invalid: 400,
    no_schema: 422,
    unknown: 500
  }.freeze

  before do
    request.body.rewind

    @payload = request.body.read
    @tenant = request.env[EventBin::EventBin::TENANT_HEADER]
  end

  post '/receive' do
    result = EventBin::EventBin.new(@tenant, @payload).run

    status RESPONSE_CODES[result.status]
    body result.messages.to_json unless result.messages.empty?
  end
end
