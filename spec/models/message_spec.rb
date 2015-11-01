require 'spec_helper'

describe Message do

  describe '#initialize' do
    it "should create a new message from the passed hash" do
      text = "I'm the body"
      phone = "15038675309"
      message = Message.new(body: text, recipient: phone)
      expect(message.body).to eq text
      expect(message.recipient).to eq phone
    end
  end

end
