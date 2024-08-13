require 'time'
require './src/infrastructure/repository/user_repository'
require './src/domain/service/auth_service'
require './src/domain/value_objects/user/name'
require './src/domain/value_objects/user/email'
require './src/domain/value_objects/user/password'

class User
    attr_accessor :id, :name, :email, :password, :created_at, :updated_at

    def initialize(request_hash)
        pp "===== user model ====="

        @auth_service = AuthService.new
        @repo         = UserRepository.new

        @id         = request_hash['id']
        @name       = Name.new(request_hash['name']).name
        @email      = Email.new(request_hash['email']).email
        @password   = Password.new(request_hash['password']).password
        @created_at = request_hash['created_at'] || Time.now.strftime("%Y-%m-%d %H:%M:%S")
        @updated_at = request_hash['updated_at'] || Time.now.strftime("%Y-%m-%d %H:%M:%S")
    end

    def login
        set_values(password_hashing: false)
        user = @repo.find(self)
        @auth_service.verify(@password, user['password'])
    end

    # 値オブジェクトが持っている値を取り出す
    def set_values(password_hashing: false)
        set_name_value
        set_email_value
        set_password_value(hashing: password_hashing)
    end

    private
    
    def set_name_value
        @name = @name.name
    end

    def set_email_value
        @email = @email.email
    end

    def set_password_value(hashing: false)
        if hashing
            @password = @auth_service.hash(@password.password)
        else
            @password = @password.password
        end
    end
end
