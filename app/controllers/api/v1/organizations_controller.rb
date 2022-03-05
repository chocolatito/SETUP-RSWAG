# frozen_string_literal: true

module Api
  module V1
    class OrganizationsController < ApplicationController
      # POST api/v1/organization/public
      def create
        @organization = Organization.create!(organization_params)
        render json: serialize_organization, status: :created
      end

      private

      def serialize_organization
        OrganizationSerializer.new(@organization).serializable_hash.to_json
      end

      def organization_params
        params.require(:organization).permit(:email,
                                             :name,
                                             :welcome_text,
                                             :address,
                                             :phone,
                                             :about_us_text,
                                             :image)
      end
    end
  end
end
