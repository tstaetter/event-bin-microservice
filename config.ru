# frozen_string_literal: true

$LOAD_PATH.unshift __dir__

require 'dotenv/load'
require 'nanites/option'
require 'json-schema'
require 'redis'
require 'lib/schema_store'
require 'lib/validator'
require 'lib/event_bin'
require 'event_bin_service'

run EventBinService
