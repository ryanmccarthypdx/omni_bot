class Message

  attr_reader :body, :recipient

  def initialize(input)
    input.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

end
