# frozen_string_literal: true

module Api
  module V1
    class AnnouncementsController < ApplicationController
      before_action :authenticate_with_token!, only: %i[update]
      before_action :admin, only: %i[create]
      before_action :set_announcement, only: %i[update]

      def show
        render json: serialize_announcement, status: :ok
      end

      def create
        @announcement = Announcement.new(announcement_params)
        @announcement.type = 'news'
        @announcement.save!
        render json: announcement_serializer, status: :created
      end

      def update
        @announcement.update!(announcement_params)
        render json: serialize_announcement, status: :ok
      end

      private

      def set_announcement
        @announcement = Announcement.find(params[:id])
      end

      def serialize_announcement
        AnnouncementSerializer.new(@announcement).serializable_hash.to_json
      end

      def announcement_params
        params.require(:announcement).permit(:content, :name, :category_id)
      end
    end
  end
end
