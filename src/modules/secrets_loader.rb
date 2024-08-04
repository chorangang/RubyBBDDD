require 'yaml'
require 'ostruct'

module SecretsLoader
  def self.load
    environment = ENV['RACK_ENV'] || 'development'
    secrets = YAML.load_file('config/secrets.yml')[environment]
    # 秘密鍵を OpenSSL::PKey::RSA インスタンスに変換　GemのJWTがこの形式を要求するため
    secrets['private_key'] = OpenSSL::PKey::RSA.new(secrets['private_key'])
    OpenStruct.new(secrets)
  end
end