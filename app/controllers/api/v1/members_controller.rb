# frozen_string_literal: true

module Api
  module V1
    class MembersController < ApplicationController
      def index
        @members = Member.kept.page(params[:page])
        @options = get_links_serializer_options('api_v1_members_path', @members)
        render json: serialize_members(@members, @options), status: :ok
      end

      private

      def serialize_members(*args)
        MembersSerializer.new(*args).serializable_hash.to_json
      end
    end
  end
end
