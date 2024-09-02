class Password
  attr_reader :value

  def initialize(value)
    @value = validate(value)
  end

  private

  def validate(value)
    if value.length < 8
      raise StandardError, "Password must be at least 8 characters long"
    end

    unless value =~ /[a-z]/
      raise StandardError, "Password must contain at least one lowercase letter"
    end

    unless value =~ /\d/
      raise StandardError, "Password must contain at least one digit"
    end

    value
  end
end