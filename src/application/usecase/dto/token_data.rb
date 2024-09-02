class TokenData
    attr_accessor :user_id, :value, :expired_at
    
    def initialize(user_id:, value:, expired_at:)
        pp "===== token DTO ====="
        @user_id = user_id
        @value = value
        @expired_at = expired_at
    end

    # エンティティからDTOを生成するためのクラスメソッド
    def self.from_entity(token)
        new(
            user_id: token.user_id,
            value: token.value,
            expired_at: token.expired_at
        )
    end

    def get_parsed_expired_at
        @expired_at.strftime("%Y-%m-%d %H:%M:%S") # SQLに適した形式で取得
    end

    def to_hash
        {
            user_id: @user_id,
            value: @value,
            expired_at: @expired_at,
        }
    end
end