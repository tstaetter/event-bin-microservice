# frozen_string_literal: true

# Access schema definitions
module SchemaStore
  class << self
    # Load the appropriate schema store.
    # RedisStore takes precedence over FileStore so if REDIS_URL is defined,
    # RedisStore will be used
    # @param [Hash] _params
    # @return BaseStore
    # @raise ArgumentError if all needed ENV vars are missing
    def load(**_params)
      return RedisStore.new if ENV['REDIS_URL']
      return FileStore.new if ENV['SCHEMAS_PATH']

      raise ArgumentError, 'None expected env vars are defined'
    end
  end

  # Base schema store
  class BaseStore
    # Get the schema for the given ID
    # @param [String] _id
    # @return Nanites::Option
    def definition(_id)
      raise NotImplementedError
    end
  end
end
