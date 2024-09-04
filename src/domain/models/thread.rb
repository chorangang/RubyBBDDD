require 'time'
require './src/domain/value_objects/thread/title'
require './src/domain/value_objects/thread/content'

class Thread
    attr_accessor :id, :title, :content, :user, :created_at, :updated_at

    def initialize(id: nil, title:, content:, user:, created_at: Time.now, updated_at: Time.now)
        @id = id
        @user = User.new(user)
        @title = Title.new(title)
        @content = Content.new(content)
        @created_at = created_at || Time.now.strftime("%Y-%m-%d %H:%M:%S")
        @updated_at = updated_at || Time.now.strftime("%Y-%m-%d %H:%M:%S")
    end

    def get_title_value
        @title.value
    end

    def get_content_value
        @content.value
    end
end