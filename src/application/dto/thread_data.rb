class ThreadData
    attr_accessor :id, :user_id, :title, :content, :author, :created_at

    def initialize(id:, user_id:, title:, content:, author:, created_at:)
        @id = id
        @user_id = user_id
        @title = title
        @content = content
        @author = author
        @created_at = created_at
    end

    def self.from_entity(thread)
        # Threadのtitle,contentと、Userのname,email,password値オブジェクトが持っている値を取り出す
        ThreadData.new(
            id:         thread.id,
            user: {
                id: thread.user_id,
                name: thread.user_name,
                content: thread.user_email,
                created_at: thread.user_created_at,
                updated_at: thread.user_updated_at
            },
            title:      thread.get_title_value,
            content:    thread.get_content_value,
            created_at: thread.created_at,
            updated_at: thread.updated_at
        )
    end

end