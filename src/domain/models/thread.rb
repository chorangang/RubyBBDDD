require 'time'
require './src/domain/value_objects/thread/title'
require './src/domain/value_objects/thread/content'

class Thread
    attr_accessor :id, :title, :content, :user_id, :created_at, :updated_at

    def initialize(id: nil, title:, content:, user_id:, created_at: Time.now, updated_at: Time.now)
        pp "===== thread ====="
        @id = id
        @title = Title.new(title)
        @content = Content.new(content)
        @user_id = user_id
        @created_at = created_at
        @updated_at = updated_at
    end
end