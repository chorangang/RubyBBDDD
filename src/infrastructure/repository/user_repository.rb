require 'pg'
require './src/infrastructure/repository/user_repository_interface'
require './src/infrastructure/repository/postgresql_repository'

class UserRepository < PostgreSQLRepository
    include UserRepositoryInterface

    def initialize()
        pp "===== user_repository ====="
        super()
    end

    def find(user)
        query = "SELECT * FROM Users WHERE id = $1"
        result = @conn.exec_params(query, [user.id])
        result.first
    end

    def findByEmail(email)
        result = @conn.exec_params(
            "SELECT * FROM Users WHERE email = $1",
            [email]
        )
        result.first
    end

    def save(user)
        result = @conn.exec_params(
            "INSERT INTO Users (name, email, password, created_at, updated_at) VALUES ($1, $2, $3, $4, $5)",
            [user[:name], user[:email], user[:password], user[:created_at], user[:updated_at]]
        )
        result.cmd_tuples > 0
    end

    def update(user)
        query = "UPDATE Users SET name = $1], updated_at = NOW() WHERE id = $2"
        result = @conn.exec_params(query, [user.name, user.id])
        result.cmd_tuples > 0
    end

    def delete(user)
        query = "DELETE FROM Users WHERE id = $1"
        result = @conn.exec_params(query, [user.id])
        result.cmd_tuples > 0
    end
end