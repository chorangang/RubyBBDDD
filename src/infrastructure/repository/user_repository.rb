require 'pg'
require './src/infrastructure/repository/user_repository_interface'
require './src/infrastructure/repository/postgresql_repository'

class UserRepository < PostgreSQLRepository
    include UserRepositoryInterface

    def initialize()
        pp "===== user_repository ====="
        super()
    end

    def find(id)
        result = @conn.exec_params("SELECT * FROM Users WHERE id = $1", [id])
        result.first
    end

    def findByEmail(email)
        result = @conn.exec_params("SELECT * FROM Users WHERE email = $1", [email])
        result.first
    end

    def save(user_data)
        result = @conn.exec_params(
            "INSERT INTO Users (name, email, password, created_at, updated_at) VALUES ($1, $2, $3, $4, $5)",
            [user_data.name, user_data.email, user_data.password, user_data.created_at, user_data.updated_at]
        )
        result.cmd_tuples > 0
    end

    def update(user_data)
        query = "UPDATE Users SET name = $1], updated_at = NOW() WHERE id = $2"
        result = @conn.exec_params(query, [user_data.name, user_data.id])
        result.cmd_tuples > 0
    end

    def delete(id)
        result = @conn.exec_params("DELETE FROM Users WHERE id = $1", [id])
        result.cmd_tuples > 0
    end
end