# frozen_string_literal: true

module Api
  module V1
    class AnnouncementsController < ApplicationController
      before_action :admin, only: %i[show]
      before_action :set_announcement, only: %i[show]
      def show
        render json: serialize_announcement, status: :ok
      end

      private

      def set_announcement
        @announcement = Announcement.find(params[:id])
      end

      def serialize_announcement
        AnnouncementSerializer.new(@announcement).serializable_hash.to_json
      end
    end
  end
end
