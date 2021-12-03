# frozen_string_literal: true

require 'spec_helper'

describe Validator do
  let :payload do
    JSON.load_file 'spec/fixtures/event.json'
  end

  let :schema do
    JSON.load_file 'spec/fixtures/default.schema.json'
  end

  shared_examples_for 'Validator' do
    context 'when validating' do
      let :validator do
        described_class.new 'default'
      end

      it 'successfully validates appropriate payload' do
        expect(validator.validate(payload).none?).to be_truthy
      end

      it 'returns validation errors for dummy payload' do
        dummy = { foo: :bar }
        expect(validator.validate(dummy).value[:error]).to be_a JSON::Schema::ValidationError
      end

      it 'returns error when no schema is found' do
        validator.instance_variable_set :'@_id', 'foo-bar'
        expect(validator.validate(payload).value[:error]).to be_a Nanites::ValueError
      end
    end
  end

  context 'when using FileStore' do
    include_context 'FileStore'

    it_behaves_like 'Validator'
  end

  context 'when using RedisStore' do
    include_context 'RedisStore'

    it_behaves_like 'Validator'
  end
end
