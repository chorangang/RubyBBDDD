require './src/infrastructure/repository/postgresql_repository'
require './src/infrastructure/repository/thread_repository_interface'

class ThreadRepository < PostgreSQLRepository
    include ThreadRepositoryInterface

    def initialize
        pp "===== thread_repository ====="
        super()
    end

    def find(id)
        pp "===== thread_repository find ====="
        query = <<~SQL
            SELECT
                Threads.id as id,
                Threads.title as title,
                Threads.body as body,
                Threads.created_at as created_at,
                Threads.updated_at as updated_at,
                Users.id AS user_id,
                Users.name AS user_name,
                Users.email AS user_email,
                Users.created_at AS user_created_at,
                Users.updated_at AS user_updated_at
            FROM Threads
            INNER JOIN Users ON Threads.user_id = Users.id
            WHERE Threads.id = $1
        SQL
        result = @conn.exec_params(query, [id])
        result.first
    end

    def select(page: 1, page_size: 20, sort: 'created_at', order: 'desc', search: nil)
        pp "===== thread_repository select ====="

        # ページネーションのオフセット計算
        offset = (page - 1) * page_size

        # SearchWordsがあるときは条件を追加
        search_condition = ''
        if !search.nil?
            search = "%#{search}%"
            search_condition = " WHERE title LIKE '#{search}'"
        end

        # クエリの構築
        query = <<~SQL
            SELECT
                Threads.id AS id,
                Threads.title AS title,
                Threads.body AS body,
                Threads.created_at AS created_at,
                Threads.updated_at AS updated_at,
                Users.id AS user_id,
                Users.name AS user_name,
                Users.email AS user_email,
                Users.created_at AS user_created_at,
                Users.updated_at AS user_updated_at
            FROM Threads
            INNER JOIN Users ON Threads.user_id = Users.id
            #{search_condition}
            ORDER BY Threads.#{sort} #{order}
            LIMIT $1 OFFSET $2;
        SQL

        result = @conn.exec_params(query, [page_size, offset])

        return {} if result.ntuples == 0

        threads = []
        result.each do |row|
            threads << row
        end

        threads
    end

    def save(user_id:, title:, body:, created_at:, updated_at:)
        pp "===== thread_repository save ====="

        query = <<~SQL
            INSERT INTO Threads (user_id, title, body, created_at, updated_at)
            VALUES ($1, $2, $3, $4, $5);
        SQL

        result = @conn.exec_params(query, [user_id, title, body, created_at, updated_at])

        result.cmd_tuples > 0
    end

    def update(id:, title:, body:, updated_at:)
        pp "===== thread_repository update ====="

        query = "UPDATE Threads SET title = $1, body = $2, updated_at = $3 WHERE id = $4;"

        result = @conn.exec_params(query, [title, body, updated_at, id])

        result.cmd_tuples > 0
    end

    def delete(id)
        pp "===== thread_repository delete ====="

        query = "DELETE FROM Threads WHERE id = $1;"

        result = @conn.exec_params(query, [id])

        result.cmd_tuples > 0
    end
end
