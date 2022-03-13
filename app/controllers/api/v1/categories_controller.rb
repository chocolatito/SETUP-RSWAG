# frozen_string_literal: true

module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :authenticate_with_token!, only: %i[update]
      before_action :admin, only: %i[update show]
      before_action :set_category, only: %i[show]

      def show
        render json: serialize_category, status: :ok
      end

      def create
        @category = Category.create!(category_params)
        render json: serialize_category, status: :created
      end

      def update
        @category = Category.find(params[:id])
        @category.update!(category_params)
        render json: serialize_category, status: :ok
      end

      def destroy
        if @category.discarded?
          render json: { errors: @category.errors.full_messages }
        else
          @category.discard
          render json: {}, status: :no_content
        end
      end

      private

      def set_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name, :description)
      end

      def serialize_category
        CategorySerializer.new(@category).serializable_hash.to_json
      end
    end
  end
end
