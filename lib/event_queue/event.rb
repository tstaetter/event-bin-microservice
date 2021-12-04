# frozen_string_literal: true

require 'date'
require 'securerandom'
require 'digest'

module EventQueue
  # Helper PORO containing attributes of the event to be published
  # on Redis for further processing
  class Event
    SOURCE_REST_API = 'ruby/rest api'

    # @param [Hash] origin The origin event received
    # @param [String] tenant The tenant ID this event belongs to
    # @param [String] source A string identifying the source the event was received from
    def initialize(origin, tenant = '', source = SOURCE_REST_API)
      @_origin = origin

      # Set more meta data
      @_meta = {
        _id: SecureRandom.uuid,
        _tenant_id: tenant,
        received_at: DateTime.now,
        received_via: source
      }
    end

    # @return String The JSON representation
    def to_json(*args)
      (json = {
        _meta: @_meta,
        payload: @_origin
      }).merge!(_hash: Digest::SHA256.hexdigest(json.to_json))
        .to_json(args)
    end
  end
end
