module TokenRepositoryInterface
    def save
        raise NotImplementedError.new("#{self.class}##{__method__} が実装されていません")
    end

    def exists
        raise NotImplementedError.new("#{self.class}##{__method__} が実装されていません")
    end
end