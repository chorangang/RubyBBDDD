require 'mysql2'
require './src/infrastructure/repository/repository'

class UserRepository < Repository
    def initialize()
        super()
    end

    def find(user)
        query = "SELECT * FROM Users WHERE email = ?"
        stmt = client.prepare(query)
        result = stmt.execute(user.email)
        result.first
    end

    def save(user)
        query = "INSERT INTO Users (name, email, password, created_at, updated_at) VALUES (?, ?, ?, ?, ?)"
        stmt = client.prepare(query)
        result = stmt.execute(user.name, user.email, user.password, user.created_at, user.updated_at)
        stmt.affected_rows
    end
end