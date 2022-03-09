# frozen_string_literal: true

module Api
  module V1
    class TestimonialsController < ApplicationController
      before_action :authenticate_with_token!, only: %i[create]
      before_action :admin, only: %i[create]

      def create
        @testimonial = Testimonial.create!(testimonial_params)
        render json: serialize_testimonial, status: :created
      end

      private

      def testimonial_params
        params.require(:testimonial).permit(:name, :content)
      end

      def serialize_testimonial
        TestimonialSerializer.new(@testimonial).serializable_hash.to_json
      end
    end
  end
end
