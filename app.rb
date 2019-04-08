require_relative 'app_controller'
class App
  attr_reader :app_controller

  def initialize
    @app_controller = AppController.new
  end

  def call(env)
    @app_controller.route(Rack::Request.new(env))
  end
end