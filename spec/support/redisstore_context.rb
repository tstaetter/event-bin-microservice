# frozen_string_literal: true

require 'spec_helper'

shared_context 'RedisStore' do
  let :redis do
    Redis.new
  end

  let :schema do
    JSON.load_file 'spec/fixtures/schemas/default.schema.json'
  end

  before do
    allow(ENV).to receive(:[]).with('REDIS_URL').and_return('redis://127.0.0.1:6379/1')
    allow(ENV).to receive(:[]).with('SCHEMAS_PATH').and_return(nil)

    # Set sample schema
    redis.set "#{SchemaStore::RedisStore::SCHEMA_KEY_PREFIX}default", schema.to_json
  end

  # Cleanup
  after do
    redis.del "#{SchemaStore::RedisStore::SCHEMA_KEY_PREFIX}default"
  end
end
