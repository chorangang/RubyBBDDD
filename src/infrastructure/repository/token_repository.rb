require './src/infrastructure/repository/token_repository_interface'

class TokenRepository < Repository
  include TokenRepositoryInterface

  def initialize
    pp "===== TokenRepository ====="
  end

  def save(token)
    query = "INSERT INTO Tokens (user_id, value, expired_at) VALUES ($1, $2, $3)"
    result = @conn.exec_params(query, [token.user_id, token.value, token.expired_at])
    result.cmd_tuples > 0
  end

  def exists(token)
    query = "SELECT * FROM Tokens WHERE value = $1"
    result = @conn.exec_params(query, [token.value])
    result.first
  end
end
