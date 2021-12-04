# frozen_string_literal: true

module EventBin
  # Event bin utility class
  class EventBin
    # Create a new service instance
    # @param [String] tenant The tenant ID
    # @param [String] payload The JSON payload taken from the request body
    def initialize(tenant, payload)
      @_tenant = tenant
      @_payload = payload
    end

    # Perform event processing
    # @return EventBin::RunResult
    def run
      validation_opt = validate

      if validation_opt.none?
        queuing_opt = queue_up
        queuing_opt.none? ? RunResult.ok : RunResult.error_result(queuing_opt.value[:error])
      else
        RunResult.error_result(validation_opt.value[:error])
      end
    end

    private

    # @return Nanites::Option
    def validate
      Validator.new(tenant).validate payload
    end

    # @return Nanites::Option
    def queue_up
      EventQueue::RedisQueue.new.enqueue payload: payload, tenant: tenant
    end

    # @return The tenant ID taken from the request header
    def tenant
      @_tenant
    end

    # @return The JSON payload
    def payload
      @_payload
    end
  end
end
