require 'time'
require './src/domain/models/user'
require './src/domain/value_objects/comment/body'

class Comment
    attr_accessor :id, :user_id, :thread_id, :body, :upvotes, :created_at, :updated_at

    def get_body
        @body.value
    end

    def set_body(body)
        @body = Body.new(body)
    end

    # upvotes cannot be nil 
    def set_upvotes(upvotes)
        @upvotes ||= upvotes
    end

    def set_created_at(created_at: Time.now.strftime("%Y-%m-%d %H:%M:%S"))
        @created_at = created_at
    end

    def set_updated_at(updated_at: Time.now.strftime("%Y-%m-%d %H:%M:%S"))
        @updated_at = updated_at
    end

    # Both body and Upvotes must not be present, but one of them must be present.
    def exists_body_or_upvotes?
        pp "===== exists_body_or_upvotes? ====="

        # 両方が存在しない場合
        return false if @body.value.nil? && !@upvotes

        # 両方が存在する場合
        return false if !@body.value.nil? && @upvotes

        true
    end
end
