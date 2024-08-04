class Serializer
  attr_accessor :body, :status, :headers

  def serialize(body = {}, status = 200, headers = { 'Content-Type' => 'application/json' })
    @body = body
    @status = status
    @headers = headers

    if body[:message]
      @body = { message: body[:message] }
    end

    if body[:status]
      @status = body[:status]
    end

    return [ [@body.to_json], @status, @headers]
  end
end