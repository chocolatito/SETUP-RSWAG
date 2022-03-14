# frozen_string_literal: true

module Paginable
  protected

  def get_links_serializer_options(links_paths, collection)
    {
      links: {
        first: send(links_paths, page: 1),
        prev: send(links_paths, page: collection.prev_page),
        current: send(links_paths, page: collection.current_page),
        next: send(links_paths, page: collection.next_page),
        last: send(links_paths, page: collection.total_pages)
      }
    }
  end

  def current_page
    (params[:page] || 1).to_i
  end
end
