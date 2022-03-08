# frozen_string_literal: true

module Api
  module V1
    class SlidesController < ApplicationController
      before_action :authenticate_with_token!, only: %i[index]
      before_action :admin, only: %i[index]

      # GET /api/v1/slides
      def index
        @slides = Slide.kept
        render json: serialize_slides, status: :ok
      end

      private

      def serialize_slides
        SlidesSerializer.new(@slides).serializable_hash.to_json
      end
    end
  end
end
