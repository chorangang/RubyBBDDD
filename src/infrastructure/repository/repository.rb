require 'pg'

class Repository
    def initialize
        pp "===== repository ====="

        @conn = connection = PG::Connection.new(
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