require 'json'
require './src/application/usecase/threads_usecase'

class ThreadsController
    def initialize
        pp "===== threads_controller ====="
        @threads_usecase = ThreadsUsecase.new
    end

    def index(req)
        res = @thread_usecase.get_threads()
        @serializer.serialize(res)
    end

    def save(req)
        body = JSON.parse(req.body)
        thread = @thread_usecase.create(body)
        res.status = 201
        res.body = JSON.generate(thread)
    end

    def show(req, id)
        pp "===== show ====="
        id = req.params['id']
        pp "id: #{id}"
        thread = @thread_usecase.show(id)
        res.status = 200
        res.body = JSON.generate(thread)
    end

    def update(req)
        id = req.params['id']
        body = JSON.parse(req.body)
        thread = @thread_usecase.update(id, body)
        res.status = 200
        res.body = JSON.generate(thread)
    end

    def destroy(req)
        id = req.params['id']
        @thread_usecase.destroy(id)
        res.status = 204
    end
end