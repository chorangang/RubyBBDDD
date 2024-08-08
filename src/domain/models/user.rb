require 'time'
require './src/infrastructure/repository/user_repository'
require './src/domain/service/auth_service'
require './src/domain/value_objects/user/name'
require './src/domain/value_objects/user/email'
require './src/domain/value_objects/user/password'

class User
    attr_accessor :id, :name, :email, :password, :created_at, :updated_at

    def initialize(request_hash)
        @auth_service = AuthService.new
        @repo         = UserRepository.new

        @id         = request_hash['id']
        @name       = Name.new(request_hash['name'])
        @email      = Email.new(request_hash['email'])
        @password   = Password.new(request_hash['password'])
        @created_at = request_hash['created_at'] || set_now
        @updated_at = request_hash['updated_at'] || set_now
    end

    def save
        # 値オブジェクトから値を取り出す
        set_values(password_hashing: true)
        @repo.save(self)
    end

    def login
        set_values(password_hashing: false)
        user = @repo.find(self)
        @auth_service.verify(@password, user['password'])
    end

    private

    def set_values(password_hashing: false)
        set_name_value
        set_email_value
        set_password_value(hashing: password_hashing)
    end

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

    def set_now
        now = Time.now
        now.strftime("%Y-%m-%d %H:%M:%S")
    end
end
