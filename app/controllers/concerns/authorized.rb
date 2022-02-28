# frozen_string_literal: true

module Authorized
<<<<<<< HEAD
  def admin?
    @current_user.role.name == 'admin'
=======
  def admin
    render json: { errors: 'Unauthorized access' }, status: :forbidden unless admin?
  end

  def admin?
    @current_user.role_id == 1
>>>>>>> feat/OT151-25 Modulo Autorización
  end

  def owner?
    params[:id].to_i == @current_user.id
  end

  def ownership?
    render json: { errors: 'Unauthorized access' }, status: :forbidden unless admin? || owner?
  end
end
