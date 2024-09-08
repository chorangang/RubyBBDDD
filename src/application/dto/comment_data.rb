class CommentData
    attr_accessor :id, :user_id, :thread_id, :body, :upvotes, :created_at, :updated_at, :user
    
    def self.from_repo(result)
        comment_data = self.new

        comment_data.id        = result['id']
        comment_data.user_id   = result['user_id']
        comment_data.thread_id = result['thread_id']
        comment_data.body      = result['body']
        comment_data.upvotes   = result['upvotes']
        comment_data.user = {
            name: result['user_name'],
        }
        comment_data.created_at = result['created_at']
        comment_data.updated_at = result['updated_at']

        comment_data
    end

    def serialize
        {
            id: @id,
            author: @user,
            body: @body,
            upvotes: @upvotes,
            created_at: @created_at,
            updated_at: @updated_at,
        }
    end
end
