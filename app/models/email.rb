class Email
  attr_accessor :manager, :subject

  def initialize(options={})
    options.each do |arg, value|
      self.instance_variable_set("@#{arg}", value)
    end
  end
end
