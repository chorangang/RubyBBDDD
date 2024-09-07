require './src/application/dto/thread_data'
require './src/domain/models/thread_entity'
require './src/infrastructure/repository/thread_repository'

class ThreadUsecase
    def initialize
        pp "===== thread_usecase ====="
        @thread_repository = ThreadRepository.new
    end

    def get_threads(query)
        pp "===== getThreads ====="

        threads = @thread_repository.select(
            page:      query['page'].to_i || 1,
            page_size: query['page_size'] || 20,
            sort:      query['sort']      || 'created_at',
            order:     query['order']     || 'desc',
            search:    query['search']    || nil
        )

        return {message: 'No content'} if threads.empty?

        res = []
        threads.each do |thread|
            res.push(ThreadData.from_repo(thread).serialize)
        end

        # 配列で返すとSeliarizeできないのラップしてHashで返す
        {threads: res}
    end

    def get_thread(id)
        pp "===== getThread ====="

        result = @thread_repository.find(id)

        return {message: "Thread not found", status: 404} if result.nil?

        # Mapperに変換してからコントローラーにHashの形で返す。
        ThreadData.from_repo(result).serialize;
    end

    def save_thread(request)
        pp "===== saveThread ====="

        @thread = ThreadEntity.new
        @thread.user_id = request['user_id'].to_i
        @thread.set_title(request['title'])
        @thread.set_body(request['body'])
        @thread.set_created_at
        @thread.set_updated_at

        result = @thread_repository.save(
            user_id:    @thread.user_id,
            title:      @thread.title.value,
            body:       @thread.body.value,
            created_at: @thread.created_at,
            updated_at: @thread.updated_at
        )

        return {message: 'Thread creation failed', status: 400} unless result

        {message: 'Thread created successfully', status: 201}
    end

    def update_thread(request, id)
        pp "===== updateThread ====="

        @thread = ThreadEntity.new
        @thread.id = id.to_i
        @thread.set_title(request['title'])
        @thread.set_body(request['body'])
        @thread.set_updated_at

        result = @thread_repository.update(
            id:    @thread.id,
            title: @thread.title.value,
            body:  @thread.body.value,
            updated_at: @thread.updated_at
        )

        return {message: 'Thread update failed', status: 400} unless result

        {message: 'Thread updated successfully', status: 200}
    end

    def delete_thread(id)
        pp "===== deleteThread ====="

        result = @thread_repository.delete(id)

        return {message: 'Thread deletion failed', status: 400} unless result

        {message: 'Thread deleted successfully', status: 200}
    end
end
