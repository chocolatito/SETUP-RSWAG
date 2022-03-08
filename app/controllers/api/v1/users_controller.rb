# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_with_token!, only: %i[update]
      before_action :authorize_request, except: :create
      before_action :find_user, except: %i[create]
      before_action :admin, only: %i[index]

      def index
        @users = User.all
        render json: @users, status: :ok
      end

      def create
        @user = User.new(user_params)
        @user.role = Role.create_or_find_by(name: 'user', description: 'usuario de la aplicacion')
        if @user.save
          UserNotifierMailer.send_signup_email(@user).deliver
          render json: @user, status: :created
          UserWelcome.with(user: @user).send_user_welcome.deliver_later
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def update
        if @user.update!(user_params)
          render json: UserSerializer.new(@user).serializable_hash.to_json
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

      def user_params
        params.require(:user).permit(:email, :password, :first_name, :last_name)
      end
    end
  end
end
