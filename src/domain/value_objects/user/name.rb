require './src/error/invalid_argument_error'

class Name
  attr_reader :name

  def initialize(value)
    @name = validate(value)
  end

  private

  def validate(value)
    if value.length < 1
      raise StandardError, 'Name must be at least 1 characters long'
    end

    if value.length > 50
      raise StandardError, 'Name cannot exceed 50 characters'
    end

    value
  end
end