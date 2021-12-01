# frozen_string_literal: true

# Access schema definitions
module SchemaStore
  class << self
    # Load the appropriate schema store
    # @param [Hash] _params
    # @return BaseStore
    def load(**_params)
      FileStore.new
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

  # Simple file store
  class FileStore < BaseStore
    SCHEMA_SUFFIX = 'schema.json'

    def initialize
      super
      @_base = ENV['SCHEMAS_PATH']
    end

    # :nodoc:
    def definition(id)
      Nanites::Option.some JSON.load_file(schema_file(id).value)
    rescue Nanites::ValueError => _e
      Nanites::Option.none
    end

    private

    # Construct the desired schema file name
    # @param [String] id The schema ID
    # @return Nanites::Option
    def schema_file(id)
      path = File.absolute_path "#{id}.#{SCHEMA_SUFFIX}", @_base

      raise IOError, "No readable schema for ID #{id} found" unless File.file?(path) && File.readable?(path)

      Nanites::Option.some path
    rescue StandardError => _e
      Nanites::Option.none
    end
  end
end
