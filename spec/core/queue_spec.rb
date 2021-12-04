# frozen_string_literal: true

require 'spec_helper'

describe EventQueue::Queue do
  let :queue do
    described_class.new
  end

  context 'when queueing events' do
    it 'raises error when called #enqueue' do
      expect do
        queue.enqueue
      end.to raise_error NotImplementedError
    end
  end
end
