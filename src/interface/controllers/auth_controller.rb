require 'json'
require './src/application/usecase/auth_usecase'
require './src/interface/serializers/serializer'

class AuthController
    def initialize
        pp "===== auth_controller ====="
        @auth_service = AuthUseCase.new
        @serializer = Serializer.new
    end

    def register(request)
        body = JSON.parse(request.body.read)
        res = @auth_service.register(body)
        pp res
        @serializer.serialize(res)
    end

    def login(request)
        body = JSON.parse(request.body.read)
        res = @auth_service.login(body)
        @serializer.serialize(res)
    end

    def logout(request)
        jwt = request.env['HTTP_AUTHORIZATION']
        res = @auth_service.logout(jwt)
        @serializer.serialize(res)
    end
end