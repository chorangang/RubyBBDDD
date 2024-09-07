require 'time'
require './src/domain/value_objects/thread/title'
require './src/domain/value_objects/thread/body'

# Threadという標準クラスがRubyに存在するため、ThreadEntityという名前にしている
class ThreadEntity
    attr_accessor :id, :user_id, :title, :body, :created_at, :updated_at, :user

    def set_title(title)
        @title = Title.new(title)
    end

    def set_body(body)
        @body = Body.new(body)
    end

    def set_created_at(created_at: Time.now.strftime("%Y-%m-%d %H:%M:%S"))
        @created_at = created_at
    end

    def set_updated_at(updated_at: Time.now.strftime("%Y-%m-%d %H:%M:%S"))
        @updated_at = updated_at
    end

    def set_user(user)
        pp "===== set_user ====="
        @user = User.new(
            id:         user[:id].to_i,
            name:       user[:name],
            email:      user[:email],
            password:   nil, # パスワードは取得しない
            created_at: user[:created_at],
            updated_at: user[:updated_at]
        )
    end
end
