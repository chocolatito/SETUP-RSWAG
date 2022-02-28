# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :authorize_request, except: :create
      before_action :find_user, except: %i[create]

      def create
        @user = User.new(user_params)
        @user.role = Role.create_or_find_by(name: 'user', description: 'usuario de la aplicacion')
        if @user.save
          UserNotifierMailer.send_signup_email(@user).deliver
          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      private

      def find_user
        @user = User.find_by!(username: params[:_username])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: 'User not found' }, status: :not_found
      end

      def user_params
        params.permit(:email, :password, :first_name, :last_name)
      end
    end
  end
end
