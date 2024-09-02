require './src/infrastructure/repository/token_repository_interface'
require './src/infrastructure/repository/postgresql_repository'

class TokenRepository < PostgreSQLRepository
  include TokenRepositoryInterface

  def initialize
    pp "===== token_repository ====="
    super()
  end

  def find(token)
    query = "SELECT * FROM Tokens WHERE value = $1"
    result = @conn.exec_params(query, [token])
    result.first
  end

  def save(token_data)
    query = "INSERT INTO Tokens (user_id, value, expired_at) VALUES ($1, $2, $3)"
    result = @conn.exec_params(query, [token_data.user_id, token_data.value, token_data.get_parsed_expired_at])
    result.cmd_tuples > 0
  end

  def delete(token)
    result = @conn.exec_params("DELETE FROM Tokens WHERE value = $1", [token])
    result.cmd_tuples > 0
  end
end
