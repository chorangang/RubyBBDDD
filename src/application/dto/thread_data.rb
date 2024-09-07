class ThreadData
    attr_accessor :id, :user_id, :title, :body, :created_at, :updated_at, user:

    # Repositoryから取得したデータを受け取って、DTOを生成する
    def self.from_repo(result)
        thread_data = self.new

        # 各属性を設定
        thread_data.id         = result['id']
        thread_data.title      = result['title']
        thread_data.body       = result['body']
        thread_data.created_at = result['created_at']
        thread_data.updated_at = result['updated_at']

        thread_data.user = {
            id:         result['user_id'],
            name:       result['user_name'],
            email:      result['user_email'],
            created_at: result['user_created_at'],
            updated_at: result['user_updated_at'],
        }

        thread_data
    end

    # Entityを受け取って、DTOを生成する
    def self.from_entity(thread)
        thread_data = self.new

        # 各属性を設定
        thread_data.id = thread.id
        thread_data.user = thread.user.nil? ? nil : {
            id: thread.user.id,
            name: thread.user.get_name_value,
            email: thread.user.get_email_value,
            created_at: thread.user.created_at,
            updated_at: thread.user.updated_at
        }
        thread_data.title      = thread.title.value
        thread_data.body       = thread.body.value
        thread_data.created_at = thread.created_at
        thread_data.updated_at = thread.updated_at

        thread_data
    end

    # hashを返す
    def serialize
        {
            id: @id,
            author: @user,
            title: @title,
            body: @body,
            created_at: @created_at,
            updated_at: @updated_at,
        }
    end
end
