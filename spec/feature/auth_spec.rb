# frozen_string_literal: true

require 'spec_helper'
require './src/interface/middleware/jwt_auth_middleware'


RSpec.describe JwtAuthMiddleware do
  let(:app) { double('app', call: [200, {}, ['OK']]) }
  let(:skip_paths) { ['/login', '/register'] }
  let(:auth_service) { instance_double(AuthService) }

  before do
    # 認証を通すパス
    non_skip_paths = Routes::ROUTES
    stub_const('ROUTES', non_skip_paths)

    # 認証を素通りするパス
    skip_paths = Routes::SKIP_PATHS
    stub_const('SKIP_PATHS', skip_paths)

    allow(AuthService).to receive(:new).and_return(auth_service)
  end

  describe '#initialize' do
    subject(:middleware) { described_class.new(app) }

    it 'sets the app correctly' do
      expect(middleware.instance_variable_get(:@app)).to eq(app)
    end

    it 'sets the skip_paths correctly' do
      expect(middleware.instance_variable_get(:@skip_paths)).to eq(skip_paths)
    end

    it 'creates an instance of AuthService' do
      expect(middleware.instance_variable_get(:@auth_service)).to eq(auth_service)
    end
  end

  describe '#call' do
    context 'when path is in SKIP_PATHS' do
      SKIP_PATHS.each do |skip_path|
        it "returns 200 for #{skip_path}" do
          get skip_path
          expect(last_response.status).to eq(200)
        end
      end
    end

    context 'when Authorization header is missing' do
      it 'returns unauthorized response' do
        get '/user'
        expect(last_response.status).to eq(401)
        expect(JSON.parse(last_response.body)).to eq({ 'message' => 'Unauthorized' })
      end
    end

    context 'when Authorization header is not a Bearer token' do
      it 'returns unauthorized response' do
        header 'Authorization', 'Basic token'
        get '/protected'
        expect(last_response.status).to eq(401)
        expect(JSON.parse(last_response.body)).to eq({ 'message' => 'Unauthorized' })
      end
    end

    context 'when token is valid' do
      let(:valid_token) { 'valid.jwt.token' }
      let(:decoded_token) { [{ 'expired' => (Time.now + 3600).to_i }] }

      before do
        allow(JWT).to receive(:decode).and_return(decoded_token)
        allow(auth_service).to receive(:authenticate).and_return(false)
      end

      it 'allows the request' do
        header 'Authorization', "Bearer #{valid_token}"
        get '/protected'
        expect(last_response.status).to eq(200)
      end
    end

    context 'when token is expired' do
      let(:expired_token) { 'expired.jwt.token' }
      let(:decoded_token) { [{ 'expired' => (Time.now - 3600).to_i }] }

      before do
        allow(JWT).to receive(:decode).and_return(decoded_token)
      end

      it 'returns unauthorized response' do
        header 'Authorization', "Bearer #{expired_token}"
        get '/protected'
        expect(last_response.status).to eq(401)
        expect(JSON.parse(last_response.body)).to eq({ 'message' => 'Token expired' })
      end
    end

    context 'when token is revoked' do
      let(:revoked_token) { 'revoked.jwt.token' }
      let(:decoded_token) { [{ 'expired' => (Time.now + 3600).to_i }] }

      before do
        allow(JWT).to receive(:decode).and_return(decoded_token)
        allow(auth_service).to receive(:authenticate).and_return(true)
      end

      it 'returns unauthorized response' do
        header 'Authorization', "Bearer #{revoked_token}"
        get '/protected'
        expect(last_response.status).to eq(401)
        expect(JSON.parse(last_response.body)).to eq({ 'message' => 'Token revoked' })
      end
    end

    context 'when JWT decoding fails' do
      let(:invalid_token) { 'invalid.jwt.token' }

      before do
        allow(JWT).to receive(:decode).and_raise(JWT::DecodeError)
      end

      it 'returns unauthorized response' do
        header 'Authorization', "Bearer #{invalid_token}"
        get '/protected'
        expect(last_response.status).to eq(401)
        expect(JSON.parse(last_response.body)).to eq({ 'message' => 'Unauthorized' })
      end
    end
  end
end