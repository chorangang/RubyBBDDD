require './src/infrastructure/repository/thread_repository'

class ThreadsUsecase
    def initialize
        pp "===== threads_usecase ====="
        @thread_repository = ThreadRepository.new
    end

    def getThread(id)
        @thread_repository.find(id)
    end
end
