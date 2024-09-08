require './src/application/usecase/comment_usecase'
require './src/interface/serializers/serializer'

class CommentsController
    def initialize
        pp "===== comments_controller ====="
        @comment_usecase = CommentUsecase.new
        @serializer = Serializer.new
    end

    def index(req, params)
        @serializer.serialize(@comment_usecase.get_comments(params[':thread_id'].to_i))
    end
    
    def save(req)
        @serializer.serialize(@comment_usecase.create_comment(JSON.parse(req.body.read)))
    end
    
    def update(req, params)
        @serializer.serialize(@comment_usecase.update_comment(JSON.parse(req.body.read), params[':id'].to_i))
    end
    
    def destroy(req, params)
        @serializer.serialize(@comment_usecase.delete_comment(params[':id'].to_i))
    end
end