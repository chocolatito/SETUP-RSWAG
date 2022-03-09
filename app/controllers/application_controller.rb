# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Authorized
  include Authenticable
  include ExceptionHandler
  include Paginable
end
