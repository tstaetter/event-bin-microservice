# frozen_string_literal: true

require 'spec_helper'

describe EventQueue::RedisQueue do
  let :queue do
    described_class.new
  end

  let :channel do
    SecureRandom.alphanumeric 10
  end

  context 'when initialized' do
    before do
      allow(ENV).to receive(:fetch).with('QUEUE_CHANNEL', 'events').and_return(channel)
    end

    it 'has a redis client set' do
      expect(queue.instance_variable_get(:'@_client')).to_not be_nil
    end

    it 'has a channel set' do
      expect(queue.instance_variable_get(:'@_channel')).to eq channel
    end
  end

  context 'when queueing events' do
    it 'returns none' do
      result = queue.enqueue(payload: JSON.load_file('spec/fixtures/event.json'),
                             tenant: 'default').none?
      expect(result).to be_truthy
    end

    it 'returns some if cannot connect' do
      allow(ENV).to receive(:[]).with('REDIS_URL').and_return('redis://redis:6379/1')

      result = queue.enqueue(payload: JSON.load_file('spec/fixtures/event.json'),
                             tenant: 'default').some?
      expect(result).to be_truthy
    end

    pending 'actually publishes the event' do
      q_event = EventQueue::Event.new payload: JSON.load_file('spec/fixtures/event.json'),
                                      tenant: 'default'

      Redis.new.subscribe_with_timeout 5, channel do |subscription|
        subscription.message do |_c, message|
          expect(q_event.to_json).to eq message
          break
        end

        queue.enqueue payload: JSON.load_file('spec/fixtures/event.json'),
                      tenant: 'default'
      end
    end
  end
end
