# frozen_string_literal: true

module SchemaStore
  # Redis schema store
  class RedisStore < BaseStore
    SCHEMA_KEY_PREFIX = 'schema_'

    def initialize
      super
      @_client = Redis.new
    end

    # :nodoc:
    def definition(id)
      raise Nanites::ValueError, "No schema for ID #{id}" unless (schema = @_client.get(schema_key(id).value))

      Nanites::Option.some schema
    rescue Nanites::ValueError => _e
      Nanites::Option.none
    end

    private

    # Construct the desired schema key
    # @param [String] id The schema ID
    # @return Nanites::Option
    def schema_key(id)
      key = "#{SCHEMA_KEY_PREFIX}#{id}"

      raise ArgumentError, "Couldn't construct valid key" unless key =~ /#{SCHEMA_KEY_PREFIX}.+/

      Nanites::Option.some key
    rescue StandardError => _e
      Nanites::Option.none
    end
  end
end
