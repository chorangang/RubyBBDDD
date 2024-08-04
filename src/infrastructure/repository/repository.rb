require 'mysql2'

class Repository
    def initialize
        @client = Mysql2::Client.new(
            host:     ENV['HOST'],
            username: ENV['MYSQL_USER'],
            password: ENV['MYSQL_PASSWORD'],
            port:     ENV['PORT'],
            database: ENV['MYSQL_DATABASE'],
        )
    end

    protected

    def client
        @client
    end
end