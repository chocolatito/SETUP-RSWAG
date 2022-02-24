# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      def create
        @user = User.new(user_params)
        if @user.save
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
