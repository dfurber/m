class NoWWW
 
  STARTS_WITH_WWW = /^www\./i
  API_REQUEST = /^\/api/i
  
  def initialize(app)
    @app = app
  end
  
  def call(env)
    if env['REQUEST_URI'] =~ API_REQUEST
      @app.call(env)
    elsif !(env['HTTP_HOST'] =~ STARTS_WITH_WWW)
      [301, { 'Location' => Rack::Request.new(env).url.sub(/http:\/\//i, 'http://www.') }, ['Redirecting...']]
    else
      @app.call(env)
    end
  end
  
end