require 'json'

class AuthSerializer
  def self.serialize(user)
    JSON.generate(user)
  end
end