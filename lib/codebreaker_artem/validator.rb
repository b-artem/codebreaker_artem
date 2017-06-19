module Validator
  def self.code_valid?(input)
    true if input =~ /^[1-6]{4}$/
  end
end
