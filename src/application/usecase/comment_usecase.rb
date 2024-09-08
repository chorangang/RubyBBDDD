require './src/domain/models/comment'
require './src/application/dto/comment_data'
require './src/infrastructure/repository/comment_repository'

class CommentUsecase
    def initialize
        pp "===== comment usecase ====="
        @comment_repo = CommentRepository.new
    end

    def get_comments(thread_id)
        pp "===== comment usecase get_comments ====="

        result = @comment_repo.list(thread_id)

        return {message: 'No Comments with this comment'} if result.empty?

        comments = []
        result.each do |row|
            comments << CommentData.from_repo(row).serialize
        end

        {comments: comments}
    end

    def create_comment(request)
        pp "===== comment usecase create_comment ====="

        @comment = Comment.new
        @comment.user_id   = request['user_id'].to_i
        @comment.thread_id = request['thread_id'].to_i
        @comment.set_body(request['body'])
        @comment.set_upvotes(request['upvotes'])

        unless @comment.exists_body_or_upvotes?
            return {message: 'Either upvotes or content must be present.', status: 400}
        end

        result = @comment_repo.save(
            user_id:   @comment.user_id,
            thread_id: @comment.thread_id,
            body:      @comment.get_body,
            upvotes:   @comment.upvotes,
        )

        return {message: 'Failed to create comment', status: 500} unless result

        {message: 'Comment created successfully'}
    end

    def update_comment(request, id)
        pp "===== comment usecase update_comment ====="

        @comment = Comment.new
        @comment.id = id
        @comment.set_body(request['body'])
        @comment.set_upvotes(request['upvotes'])

        unless @comment.exists_body_or_upvotes?
            return {message: 'Either upvotes or content must be present.', status: 400}
        end

        result = @comment_repo.update(id: id, body: @comment.get_body, upvotes: @comment.upvotes)

        return {message: 'Failed to update comment', status: 500} unless result

        {message: 'Comment updated successfully'}
    end

    def delete_comment(id)
        pp "===== comment usecase delete_comment ====="

        result = @comment_repo.delete(id)

        return {message: 'Failed to delete comment', status: 500} unless result

        {message: 'Comment deleted successfully'}
    end
end