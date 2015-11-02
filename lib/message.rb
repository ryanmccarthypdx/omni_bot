class Message

  attr_reader :body, :recipient, :client, :from

  def initialize(input)
    input.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  def prepare_client
    if Sinatra::Base.environment == :test
      sid = ENV['TEST_TWILIO_SID']
      auth_token = ENV['TEST_TWILIO_AUTH_TOKEN']
      @from = ENV['TEST_TWILIO_FROM_NUMBER']
    else
      sid = ENV['PRODUCTION_TWILIO_SID']
      auth_token = ENV['PRODUCTION_TWILIO_AUTH_TOKEN']
      @from = ENV['PRODUCTION_TWILIO_FROM_NUMBER']
    end

    @client = Twilio::REST::Client.new(sid, auth_token)
  end

  def send
    prepare_client
    response = client.messages.create(body: body, to: recipient, from: from)
  end

end
