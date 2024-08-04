require 'bcrypt'

class AuthService
  # Passwordのハッシュ化
  def hash(password)
    BCrypt::Password.create(password)
  end

  # Passwordの検証
  def verify(password, hashed_password)
    BCrypt::Password.new(hashed_password) == password
  end
end