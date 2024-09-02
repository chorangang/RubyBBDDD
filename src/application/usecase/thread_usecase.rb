class ThreadUsecase
    def initialize(thread_repository)
        @thread_repository = thread_repository
    end
    
    def create_thread(thread)
        @thread_repository.create_thread(thread)
    end
    
    def get_thread(thread_id)
        @thread_repository.get_thread(thread_id)
    end
    
    def get_threads
        @thread_repository.get_threads
    end
    
    def update_thread(thread)
        @thread_repository.update_thread(thread)
    end
    
    def delete_thread(thread_id)
        @thread_repository.delete_thread(thread_id)
    end
end
