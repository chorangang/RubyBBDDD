# spec/user_repository_spec.rb
require 'pg'
require './src/infrastructure/repository/user_repository'
require './src/domain/models/user'

RSpec.describe UserRepository do
    let(:user) {
        User.new(
            name: 'testUser',
            email: 'testuser@example.com',
            password: 'P@ssw0rd',
            created_at: Time.now,
            updated_at: Time.now
        )
    }
    let(:repository) { UserRepository.new }

    before(:each) do
        # Prepare the test database
        repository.instance_variable_get(:@conn).exec('TRUNCATE TABLE Users RESTART IDENTITY CASCADE')
    end

    describe '#find' do
        it 'returns a user when a valid email is provided' do
        repository.save(user)
        found_user = repository.find(user)
        expect(found_user['email']).to eq(user.email)
        expect(found_user['name']).to eq(user.name)
        end

        it 'returns nil when an invalid email is provided' do
        found_user = repository.find(user)
        expect(found_user).to be_nil
        end
    end

    describe '#findById' do
        it 'returns a user when a valid id is provided' do
        repository.save(user)
        found_user = repository.findById(user)
        expect(found_user['email']).to eq(user.email)
        expect(found_user['name']).to eq(user.name)
        end

        it 'returns nil when an invalid id is provided' do
        user.id = 999
        found_user = repository.findById(user)
        expect(found_user).to be_nil
        end
    end

    describe '#save' do
        it 'saves a user to the database and returns the number of affected rows' do
        result = repository.save(user)
        expect(result).to eq(1)
        end

        it 'returns 0 when the insert fails' do
        allow(repository.instance_variable_get(:@conn)).to receive(:exec_params).and_return(double(cmd_tuples: 0))
        result = repository.save(user)
        expect(result).to eq(0)
        end
    end
end
