require 'time'
require './src/infrastructure/repository/user_repository'
require './src/error/invalid_argument_error'
require './src/domain/value_objects/user/name'
require './src/domain/value_objects/user/email'
require './src/domain/value_objects/user/password'
require './src/domain/service/user_domain_service'

class User
    attr_accessor :id, :name, :email, :password, :created_at, :updated_at

    def initialize(request_hash)
        @user_domain_service = UserDomainService.new
        @repo = UserRepository.new

        @id = request_hash['id']
        @name = Name.new(request_hash['name'])
        @email = Email.new(request_hash['email'])
        @password = Password.new(request_hash['password'])
        @created_at = request_hash['created_at'] || set_now
        @updated_at = request_hash['updated_at'] || set_now
    end

    def save
        # 値オブジェクトから値を取り出す
        @name = @name.name
        @email = @email.email
        @password = @user_domain_service.hash(@password.password)

        @repo.save(self)
    end

    private

    def set_now
        now = Time.now
        now.strftime("%Y-%m-%d %H:%M:%S")
    end
end
