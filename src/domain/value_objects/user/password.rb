class Password
  attr_reader :password

  def initialize(value)
    @password = validate(value)
  end

  private

  def validate(value)
    if value.length < 8
      raise StandardError, "Password must be at least 8 characters long"
    end

    unless value =~ /[A-Z]/
      raise StandardError, "Password must contain at least one uppercase letter"
    end

    unless value =~ /[a-z]/
      raise StandardError, "Password must contain at least one lowercase letter"
    end

    unless value =~ /\d/
      raise StandardError, "Password must contain at least one digit"
    end

    unless value =~ /[!@#$%^&*]/
      raise StandardError, "Password must contain at least one special character"
    end

    value
  end
end