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
<<<<<<< HEAD
    rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
=======
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
>>>>>>> Added serializer and exception handler
    rescue_from ActionController::ParameterMissing do |e|
      render json: { error: e.message }, status: :bad_request
    end
  end

  private

  def handle_unauthenticated
    render json: { ok: false }, status: :unauthorized
  end

<<<<<<< HEAD
  def handle_record_invalid(errors)
=======
  def four_twenty_two(errors)
>>>>>>> Added serializer and exception handler
    render json: { message: errors.message }, status: :unprocessable_entity
  end
end
