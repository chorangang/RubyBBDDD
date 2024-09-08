class Body
    MAX = 1000

    attr_reader :value

    def initialize(value)
        @value = validate(value)
    end

    def validate(value)
        # ''がnil?でfalseになるので、nilに変換する
        value = value === '' ? nil : value

        # 値がある場合は最大の文字数を超えていないか確認
        unless value.nil?
            raise 'Body is too long' if value.length > MAX
        end

        value
    end
end