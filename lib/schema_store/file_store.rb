# frozen_string_literal: true

module SchemaStore
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
