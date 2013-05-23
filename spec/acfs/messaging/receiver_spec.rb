require 'spec_helper'

module My
  class CustomReceiver
    include Acfs::Messaging::Receiver
  end
end

describe Acfs::Messaging::Receiver do
  let(:rcv_class) { My::CustomReceiver }
  after { rcv_class.queue nil }

  describe '.queue' do
    it 'should return queue name based on class name' do
      expect(rcv_class.queue).to be == 'my.custom_receiver'
    end

    it 'should set and return custom queue name' do
      rcv_class.queue 'special.queue.name'

      expect(rcv_class.queue).to be == 'special.queue.name'
    end
  end

  describe '.receive' do
    it 'should receive messages' do
      rcv_class.instance.should_receive(:receive).with(anything, anything, 'Hello!')

      ch = Acfs::Messaging::Client.instance.channel
      ex = ch.default_exchange
      ex.publish('Hello!', routing_key: 'my.custom_receiver')

      sleep 1.0
    end
  end
end
