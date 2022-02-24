# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
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

      def user_params
        params.require(:user).permit(:email, :password, :first_name, :last_name)
      end
    end
  end
end
