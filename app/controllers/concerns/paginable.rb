# frozen_string_literal: true

module Paginable
  protected

  def get_links_serializer_options(links_paths, collection)
    {
      links: {
        first: send(links_paths, page: 1),
        last: send(links_paths, page: collection.total_pages),
        prev: send(links_paths, page: collection.prev_page),
        next: send(links_paths, page: collection.next_page)
      }
    }
  end

  def current_page
    (params[:page] || 1).to_i
  end
end
