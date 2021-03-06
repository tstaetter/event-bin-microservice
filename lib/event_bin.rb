# frozen_string_literal: true

module EventBin
  # PORO holding the result of a EventBin run
  class RunResult
    # Supported result codes
    module Codes
      OK        = :ok
      INVALID   = :invalid
      NO_SCHEMA = :no_schema
      UNKNOWN   = :unknown
    end

    attr_reader :status, :messages

    # @param [Symbol] status Status code as defined in [EventBin::RunResult::Codes]
    # @param [Array] messages Optional message payloads
    def initialize(status = Codes::UNKNOWN, *messages)
      @status = status
      @messages = messages || []
    end

    class << self
      # Factory method creating a 'successful' RunResult
      # @see #create
      def ok(*messages)
        create Codes::OK, *messages
      end

      # Factory method creating a 'invalid' RunResult
      # @see #create
      def invalid(*messages)
        create Codes::INVALID, *messages
      end

      # Factory method creating a 'no_schema' RunResult
      # @see #create
      def no_schema(*messages)
        create Codes::NO_SCHEMA, *messages
      end

      # Factory method creating a 'unknown' RunResult
      # @see #create
      def unknown(*messages)
        create Codes::UNKNOWN, *messages
      end

      # Factory method creating an instance of RunResult
      # @see #initialize
      def create(status, *messages)
        RunResult.new status, *messages
      end

      # Factory method returning the corresponding RunResult for the given error value
      # @param [StandardError] value The error retrieved
      # @return RunResult
      def error_result(value)
        case value
        when JSON::Schema::ValidationError
          RunResult.invalid value
        when Nanites::ValueError
          RunResult.no_schema value
        else
          RunResult.unknown value
        end
      end
    end
  end

  # Event bin utility class
  class EventBin
    # The header name transporting the tenant ID
    TENANT_HEADER = 'X-BIN-TENANT'

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
      validator = Validator.new tenant
      validation_opt = validator.validate payload

      validation_opt.none? ? RunResult.ok : RunResult.error_result(validation_opt.value[:error])
    end

    private

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
