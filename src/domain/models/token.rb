require 'time'

class Token
  attr_accessor :user_id, :value, :expired_at

  def initialize(user_id, value: nil, expired_at: Time.now + 60 * 60)
    pp "===== token ====="
    @user_id = user_id
    @expired_at = expired_at
  end
end