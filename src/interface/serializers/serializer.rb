class Serializer
  attr_accessor :body, :status, :headers

  def serialize(body = {}, status = 200, headers = { 'Content-Type' => 'application/json' })
    @body = body
    @status = status
    @headers = headers

    if body[:status]
      @status = body[:status]
    end

    pp @body

    return [ [@body.to_json], @status, @headers]
  end
end