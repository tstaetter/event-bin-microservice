# frozen_string_literal: true

require 'json'
require 'json-schema'
require 'redis'
require 'nanites/option'
require 'lib/schema_store/schema_store'
require 'lib/schema_store/file_store'
require 'lib/schema_store/redis_store'
require 'lib/validator'
require 'lib/event_queue/event'
require 'lib/event_queue/queue'
require 'lib/event_bin/run_result'
require 'lib/event_bin/event_bin'
require 'event_bin_service'
require 'support/filestore_context'
require 'support/redisstore_context'

UUID_REGEX = /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
