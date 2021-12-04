# frozen_string_literal: true

module EventQueue
  # Base class for all queue producers
  class Queue
    # Enqueue given payload
    # @param [Hash] _params The payload parameters needed for queuing
    # @return Nanites::Option
    def enqueue(**_params)
      raise NotImplementedError
    end
  end

  # Adapter for Redis as queue. Actually publishes the event on a
  # channel defined in ENV['QUEUE_CHANNEL']
  class RedisQueue < Queue
    def initialize
      super

      @_client = Redis.new
      @_channel = ENV.fetch 'QUEUE_CHANNEL', 'events'
    end

    # @param [Hash] params The parameter hash. Must contain :payload and :tenant, where :payload defines
    #   the actual event and :tenant the ID of the tenant the event belongs to
    # @see Queue#enqueue
    def enqueue(**params)
      q_event = Event.new params[:payload], params[:tenant]

      Redis.new.publish @_channel, q_event.to_json

      Nanites::Option.none
    rescue StandardError => e
      Nanites::Option.some message: 'Error on queueing', error: e
    end
  end
end
