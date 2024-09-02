require 'time'

class Token
  attr_accessor :user_id, :value, :expired_at

  def initialize(user_id, value = nil, expired_at = nil)
    pp "===== token ====="
    @user_id = user_id || nil
    @value = value || nil
    @expired_at = expired_at || Time.now + 60 * 60
  end

  def to_hash
    return {
      user_id: @user_id,
      value: @value,
      expired_at: @expired_at,
    }
  end

  def set_values(token_values)
    @user_id = token_values[:user_id] || @user_id
    @value = token_values[:value] || @value
    @expired_at = token_values[:expired_at] || @expired_at
    self
  end
end