class Name
  attr_reader :value

  def initialize(value)
    # nilを許容する
    @value = validate(value) if value
  end

  private

  def validate(value)
    if value.length > 50
      raise StandardError, 'Name cannot exceed 50 characters'
    end

    value
  end
end