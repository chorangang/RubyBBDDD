require 'rack/test'
require './src/application/usecase/auth_usecase'
require './src/domain/models/user'
require './src/domain/models/token'

RSpec.describe AuthUseCase do
  subject { described_class.new }

  describe '#register' do
    context "正常に動くRegister"
      before do
        request_hash = {
          name: 'Test User',
          email: 'test@example.com',
          password: 'P@ssw0rd'
        }
      end
      it "api/registerを叩いてSuccessMessageを返すこと" do
        expected(subject.register(request_hash)).to eq({
          message: 'User created successfully',
          status: 201
        })
      end
    end

    # context "異常に動くRegister" do
    #   before do
    #     request_hash = {
    #       name: '',
    #       email: 'test@example.com',
    #       password: 'P@ssw0rd'
    #     }
    #   end

    #   it "Userモデルがインスタンス化でバリデーションエラーを吐く"

    #   end
    # end

end