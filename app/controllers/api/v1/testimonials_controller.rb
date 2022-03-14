# frozen_string_literal: true

module Api
  module V1
    class TestimonialsController < ApplicationController
<<<<<<< HEAD
      before_action :authenticate_with_token!, only: %i[create]
      before_action :admin, only: %i[create]

      def create
        @testimonial = Testimonial.create!(testimonial_params)
        render json: serialize_testimonial, status: :created
=======
      def index
        @testimonials = Testimonial.kept.page(params[:page])
        @options = get_links_serializer_options('api_v1_testimonials_path', @testimonials)
        render json: serialize_testimonial(@testimonials, @options), status: :ok
      end

      def create
        @testimonial = Testimonial.create!(testimonial_params)
        render json: serialize_testimonial(@testimonial), status: :created
>>>>>>> 1061418 (Setup Kaminari and add pagination to testimonial)
      end

      private

      def testimonial_params
        params.require(:testimonial).permit(:name, :content)
      end

      def serialize_testimonial(*args)
        TestimonialSerializer.new(*args).serializable_hash.to_json
      end
    end
  end
end
