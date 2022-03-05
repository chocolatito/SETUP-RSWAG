# frozen_string_literal: true

module Api
  module V1
    class CategoriesController < ApplicationController
      # POST /api/v1/categories
      def create
        @category = Category.create!(category_params)
        render json: serialize_category, status: :created
      end

      private

      def category_params
        params.require(:category).permit(:name, :description)
      end

      def serialize_category
        CategorySerializer.new(@category).serializable_hash.to_json
      end
    end
  end
end
