require 'json'
require './src/application/usecase/auth_usecase'
require './src/interface/serializers/serializer'

class AuthController
    def initialize
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
        authorization = request.env['HTTP_AUTHORIZATION']
        body = JSON.parse(request.body.read)
        res = @auth_service.logout(body)
        @serializer.serialize(res)
    end
end