class Content
    MAX_LENGTH = 1000

    attr_reader :value

    def initialize(value)
        pp "===== thread content ====="
        @value = validate(value)
    end

    private

    def validate_length(value)
        raise ArgumentError, "Content cannot be null" if value.empty?
        raise ArgumentError, "Content length exceeds maximum allowed length" if value.length > MAX_LENGTH
        value
    end
end