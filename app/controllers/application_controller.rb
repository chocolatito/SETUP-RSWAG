# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Authorized
  include Authenticable
end
