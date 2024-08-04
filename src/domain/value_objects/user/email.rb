require './src/error/invalid_argument_error'

class Email
  attr_reader :email

  def initialize(value)
    @email = validate(value)
  end

  private

  def validate(value)
    if value.length < 6
      raise StandardError, 'Email must be at least 6 characters long'
    end

    if value.length > 50
      raise StandardError, 'Email cannot exceed 50 characters'
    end

    unless value.match?(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
      raise StandardError, 'Invalid email format'
    end

    value
  end
end