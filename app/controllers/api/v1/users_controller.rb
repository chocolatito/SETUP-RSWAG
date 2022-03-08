# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_with_token!, only: %i[update]
      before_action :find_user, except: %i[create]
      before_action :admin, only: %i[index]
      before_action :ownership?, only: %i[update]

      def index
        @users = User.all
        render json: @users, status: :ok
      end

      def create
        @user = User.new(user_params)
        @user.role = Role.create_or_find_by(name: 'user', description: 'usuario de la aplicacion')
        if @user.save
          UserNotifierMailer.send_signup_email(@user).deliver
          token = JsonWebToken.encode(user_id: @user.id)
          render json: { serialize_user: serialize_user, token: token }, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def update
        if @user.update!(user_params)
          render json: serialize_user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      private

      def find_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: 'User not found' }, status: :not_found
      end

      def serialize_user
        UserSerializer.new(@user).serializable_hash.to_json
      end

      def user_params
        params.require(:user).permit(:email, :password, :first_name, :last_name)
      end
    end
  end
end
