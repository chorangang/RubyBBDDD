require './src/infrastructure/repository/postgresql_repository'
require './src/infrastructure/repository/thread_repository_interface'

class ThreadRepository < PostgreSQLRepository
    include ThreadRepositoryInterface

    def initialize
        pp "===== thread_repository ====="
        super()
    end

    def find(id)
        query = <<~SQL
            SELECT
                Threads.id,
                Threads.title,
                Threads.content,
                Threads.created_at,
                Threads.updated_at,
                Users.id AS user_id,
                Users.name AS user_name,
                Users.email AS user_email,
                Users.created_at AS user_created_at,
                Users.updated_at AS user_updated_at,
            FROM Threads
            INNER JOIN Users ON Threads.user_id = Users.id
            WHERE Threads.id = $1
        SQL
        result = @conn.exec_params(query, [id])
        result.first
    end

    def select()
        @conn.query("SELECT * FROM threads")
    end

    def save(thread)
    end

    def update(id, thread)
    end

    def define(id)
    end
end