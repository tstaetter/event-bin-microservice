# frozen_string_literal: true

require 'json'
require 'json-schema'
require 'redis'
require 'nanites/option'
require 'lib/schema_store/schema_store'
require 'lib/schema_store/file_store'
require 'lib/schema_store/redis_store'
require 'lib/validator'
require 'lib/event_bin'
require 'event_bin_service'

# Delete REDIS_URL from ENV so the FileStore is always
# used inside specs
ENV.delete 'REDIS_URL'
