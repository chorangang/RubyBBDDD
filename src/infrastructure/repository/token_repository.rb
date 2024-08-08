class TokenRepository
  def save(token)
    query = "INSERT INTO Tokens (user_id, value, expired_at) VALUES (?, ?, ?)"
    stmt = client.prepare(query)
    stmt.execute(token.user_id, token.value, token.expired_at)
  end

  def exists(token)
      query = "SELECT * FROM Tokens WHERE value = ?"
      stmt = client.prepare(query)
      result = stmt.execute(token.value)
      result.first
  end
end