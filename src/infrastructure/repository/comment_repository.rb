require './src/infrastructure/repository/postgresql_repository'
require './src/infrastructure/repository/comment_repository_interface'

class CommentRepository < PostgreSQLRepository
    include CommentRepositoryInterface

    def initialize
        pp "===== comment repository ====="
        super()
    end

    def list(thread_id)
        pp "===== comment repository list ====="

        query = <<~SQL
            SELECT
                Comments.id as id,
                Comments.body as body,
                Comments.upvotes as upvotes,
                Comments.created_at as created_at,
                Comments.updated_at as updated_at,
                Users.name as user_name
            FROM Comments
            INNER JOIN Users ON Comments.user_id = Users.id
            WHERE Comments.thread_id = $1
        SQL

        result = @conn.exec_params(query, [thread_id])

        comments = []
        result.map do |row|
            comments << row
        end

        comments
    end

    def save(user_id:, thread_id:, body:, upvotes:)
        pp "===== comment repository save ====="

        # boolean casts to integer
        upvotes = upvotes ? 1 : 0

        query = "INSERT INTO Comments (user_id, thread_id, body, upvotes) VALUES ($1, $2, $3, $4)"

        result = @conn.exec_params(query, [user_id, thread_id, body, upvotes])

        result.cmd_tuples > 0
    end

    def update(id:, body:, upvotes:)
        pp "===== comment repository update ====="

        # boolean casts to integer
        upvotes = upvotes ? 1 : 0

        query = "UPDATE Comments SET body = $1, upvotes = $2 WHERE id = $3"

        result = @conn.exec_params(query, [body, upvotes, id])

        pp result
        pp query
        pp id, body, upvotes

        result.cmd_tuples > 0
    end

    def delete(id)
        pp "===== comment repository delete ====="

        query = "DELETE FROM Comments WHERE id = $1"

        result = @conn.exec_params(query, [id])

        result.cmd_tuples > 0
    end
end