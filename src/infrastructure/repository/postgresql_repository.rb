require 'pg'

class PostgreSQLRepository
    def initialize
        pp "===== postgresql_repository ====="

        @conn = PG::Connection.new(
            host: ENV['HOST'],
            port: ENV['PORT'],
            dbname: ENV['DB_NAME'],
            user: ENV['USER'],
            password: ENV['PASSWORD']
        )
    end

    protected

    def connect
        @conn
    end
end