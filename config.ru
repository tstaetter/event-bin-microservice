# frozen_string_literal: true

$LOAD_PATH.unshift __dir__

require 'dotenv/load'
require 'nanites/option'
require 'json-schema'
require 'redis'
require 'lib/schema_store/schema_store'
require 'lib/schema_store/file_store'
require 'lib/schema_store/redis_store'
require 'lib/validator'
require 'lib/event_queue/event'
require 'lib/event_queue/queue'
require 'lib/event_bin/run_result'
require 'lib/event_bin/event_bin'
require 'event_bin_service'

run EventBinService
