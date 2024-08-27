module UserRepositoryInterface
    def find 
        raise NotImplementedError.new("#{self.class}##{__method__} が実装されていません")
    end

    def findByEmail
        raise NotImplementedError.new("#{self.class}##{__method__} が実装されていません")
    end

    def save
        raise NotImplementedError.new("#{self.class}##{__method__} が実装されていません")
    end

    def update
        raise NotImplementedError.new("#{self.class}##{__method__} が実装されていません")
    end

    def delete
        raise NotImplementedError.new("#{self.class}##{__method__} が実装されていません")
    end
end
