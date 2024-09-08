module CommentRepositoryInterface
    def list(post_id)
        raise NotImplementedError.new("#{self.class}##{__method__} が実装されていません")
    end

    def save(comment)
        raise NotImplementedError.new("#{self.class}##{__method__} が実装されていません")
    end

    def update(comment)
        raise NotImplementedError.new("#{self.class}##{__method__} が実装されていません")
    end

    def delete(comment)
        raise NotImplementedError.new("#{self.class}##{__method__} が実装されていません")
    end
end