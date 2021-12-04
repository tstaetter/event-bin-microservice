# frozen_string_literal: true

require 'spec_helper'

shared_context 'FileStore' do
  before do
    allow(ENV).to receive(:[]).with('REDIS_URL').and_return(nil)
    allow(ENV).to receive(:[]).with('SCHEMAS_PATH').and_return('spec/fixtures/schemas')
    allow(ENV).to receive(:fetch).with('QUEUE_CHANNEL', 'events').and_return('events')
  end
end
