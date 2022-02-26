# frozen_string_literal: true

module Authenticable
  def current_user
    @current_user ||= User.find_by(token: request.headers['Authorization'])
  end

  def authenticate_with_token!
    return if current_user.blank?

    render json: { errors: 'Not authenticated' },
           status: :forbidden
  end
end
