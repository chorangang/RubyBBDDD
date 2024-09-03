class Title
    MAX_LENGTH = 255

    attr_reader :value

    def initialize(value)
        pp "===== thread title ====="
        @value = validate(value)
    end

    def validate(value)
        raise 'Title cannot be empty' if value.empty?
        raise 'Title cannot be more than 255 characters' if value.length > MAX::LENGTH
        value
    end
end