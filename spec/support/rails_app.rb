require 'rails/all'

ActiveRecord::Base.establish_connection(adapter: :sqlite3, database: ":memory:")

class TestApp < Rails::Application
  config.secret_key_base = "yeehaw"
  config.logger = Logger.new('/dev/null')
  Rails.logger = config.logger

  routes.draw do
    get "/test" => "test#index"
    get "/:user_id/:widget_thing_id" => "test#index"
  end
end

class TestController < ActionController::Base
  def index
    render json: {
      params: params.to_unsafe_h.except(:action, :controller),
      headers: request.headers.to_h.select { |k, _| k.start_with?('HTTP_') },
    }
  end
end
