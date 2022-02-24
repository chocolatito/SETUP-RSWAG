# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  # Define custom error subclasses - rescue catches `StandardErrors`
  class AuthenticationError < StandardError; end

  included do
    # Define custom handlers
    rescue_from ExceptionHandler::AuthenticationError, with: :handle_unauthenticated
    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { message: e.message }, status: :not_found
    end
    rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
    rescue_from ActionController::ParameterMissing do |e|
      render json: { error: e.message }, status: :bad_request
    end
  end

  private

  def handle_unauthenticated
    render json: { ok: false }, status: :unauthorized
  end

  def handle_record_invalid(errors)
    render json: { message: errors.message }, status: :unprocessable_entity
  end
end
