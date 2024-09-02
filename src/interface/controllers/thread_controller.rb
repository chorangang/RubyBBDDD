class ThreadsController
    def initialize(thread_usecase)
        pp "===== threads_controller ====="
        @thread_usecase = thread_usecase
    end

    def index(req)
        res = @thread_usecase.get_threads()
        @serializer.serialize(res)
    end

    def create(req, res)
        body = JSON.parse(req.body)
        thread = @thread_usecase.create(body)
        res.status = 201
        res.body = JSON.generate(thread)
    end

    def show(req, res)
        id = req.params['id']
        thread = @thread_usecase.show(id)
        res.status = 200
        res.body = JSON.generate(thread)
    end

    def update(req, res)
        id = req.params['id']
        body = JSON.parse(req.body)
        thread = @thread_usecase.update(id, body)
        res.status = 200
        res.body = JSON.generate(thread)
    end

    def destroy(req, res)
        id = req.params['id']
        @thread_usecase.destroy(id)
        res.status = 204
    end
end