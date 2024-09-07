require 'json'
require './src/application/usecase/thread_usecase'

class ThreadsController
    def initialize
        pp "===== threads_controller ====="
        @thread_usecase = ThreadUsecase.new
        @serializer = Serializer.new
    end

    def index(req, params)
        @serializer.serialize(@thread_usecase.get_threads(params))
    end
    
    def show(req, params)
        @serializer.serialize(@thread_usecase.get_thread(params[':id'].to_i))
    end

    def save(req)
        @serializer.serialize(@thread_usecase.save_thread(JSON.parse(req.body.read)))
    end
    
    
    def update(req, params)
        @serializer.serialize(@thread_usecase.update_thread(JSON.parse(req.body.read), params[':id'].to_i))
    end

    def destroy(req, params)
        @serializer.serialize(@thread_usecase.delete_thread(params[':id'].to_i))
    end
end