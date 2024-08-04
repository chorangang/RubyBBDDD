class ErrorHandlingMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    p "===== ErrorHandlingMiddleware ====="
    begin
      @app.call(env)
    rescue StandardError => e
      p "===== Caught an error: #{e.message} ====="
      error_response(e)
    rescue NoMethodError => e
      p "===== Caught an NoMethodError: #{e.message} ====="
      error_response(e)
    rescue Mysql2::Error => e
      p "===== Caught an Mysql2::Error: #{e.message} ====="
      error_response(e)
    end
  end

  private

  def error_response(error)
    [
      500,
      { 'Content-Type' => 'application/json' },
      [{ error: error.message }.to_json]
    ]
  end
end
