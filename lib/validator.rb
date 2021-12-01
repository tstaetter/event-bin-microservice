# frozen_string_literal: true

# Validation for the JSON payload
class Validator
  # Create a new Validator instance
  # @param [String] id The schema ID
  def initialize(id)
    @_id = id
    @_store = SchemaStore.load
  end

  # Validate given payload
  # @param [Hash] payload
  # @return Nanites::Option if Some, validation errors are returned
  def validate(payload)
    JSON::Validator.validate! @_store.definition(@_id).value, payload
    Nanites::Option.none
  rescue Nanites::ValueError => e
    Nanites::Option.some message: 'No schema found', error: e
  rescue JSON::Schema::ValidationError => e
    Nanites::Option.some message: e.message, error: e
  end
end
