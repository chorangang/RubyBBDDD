require 'time'
require './src/infrastructure/repository/user_repository'
require './src/domain/service/auth_service'
require './src/domain/value_objects/user/name'
require './src/domain/value_objects/user/email'
require './src/domain/value_objects/user/password'

class User
    attr_accessor :id, :name, :email, :password, :created_at, :updated_at

    def initialize(id:, name:, email:, password:, created_at:, updated_at:)
        pp "===== entity user ====="

        @auth_service = AuthService.new

        @id         = id
        @name       = Name.new(name)
        @email      = Email.new(email)
        @password   = Password.new(password)
        @created_at = created_at || Time.now.strftime("%Y-%m-%d %H:%M:%S")
        @updated_at = updated_at || Time.now.strftime("%Y-%m-%d %H:%M:%S")
    end

    # 値オブジェクトが持っている値を取り出す

    def get_name_value
        @name.value
    end

    def get_email_value
        @email.value
    end

    def get_password_value
        @password.value
    end

    def set_name_value(name)
        @name = Name.new(name)
    end

    def set_email_value(email)
        @email = Email.new(email)
    end
    
    def set_password_value(password)
        @password = Password.new(password)
    end
end
