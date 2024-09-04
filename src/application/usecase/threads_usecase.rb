require './src/infrastructure/repository/thread_repository'

class ThreadsUsecase
    def initialize
        pp "===== threads_usecase ====="
        @thread_repository = ThreadRepository.new
    end

    def getThread(id)
        result = @thread_repository.find(id)
        pp result

        return {message: "Thread not found"} if result.nil?

        @thread = Thread.new(result)

        ThreadData.from_entity(@thread).serialize_to_hash
    end
end
