# frozen_string_literal: true

module HandleImages
  extend ActiveSupport::Concern
  def image_url
    image.url if image.attached?
  rescue StandardError => e
    e.message.to_s
    ''
  end

  def upload_image(path_image)
    return nil if path_image.blank?

    begin
      image.attach(
        io: File.open(path_image),
        filename: SecureRandom.uuid,
        content_type: 'image/jpeg'
      )
    rescue Errno::ENOENT => e
      e.message
    end
  end
end
