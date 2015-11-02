require 'spec_helper'

describe Message do

  describe '#new' do
    it "should create a new message from the passed hash" do
      text = "I'm the body"
      phone = "15038675309"
      message = Message.new(body: text, recipient: phone)
      expect(message.body).to eq text
      expect(message.recipient).to eq phone
    end
  end

  describe '#prepare_client' do
    it "should set the message client properly" do
      text = "I'm the body"
      phone = "15038675309"
      message = Message.new(body: text, recipient: phone)
      message.prepare_client
      expect(message.client.account_sid).to eq ENV['TEST_TWILIO_SID']
    end
  end

  describe '#send' do
    it "should send the message when given good info" do
      text = "I'm the body"
      phone = "15038675309"
      message = Message.new(body: text, recipient: phone)
      success_response_class = Twilio::REST::Message
      response = message.send
      expect(response.class).to eq success_response_class
    end

    it "should raise an Twilio::REST::RequestError when given bad info" do
      text = "I'm the body"
      bad_phone = "15005550001"
      message = Message.new(body: text, recipient: bad_phone)
      expect {message.send}.to raise_error(Twilio::REST::RequestError)
    end
  end
end
