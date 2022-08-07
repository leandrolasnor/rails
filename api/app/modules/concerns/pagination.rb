# frozen_string_literal: true

module Pagination
  extend ActiveSupport::Concern
  attr_reader :items_count
  attr_reader :pages_count

  def default_per_page
    10
  end

  def serializer
    params.dig(:pagination, :serializer)
  end

  def current_page
    (params.dig(:pagination, :current_page) || 1).to_i
  end

  def per_page
    (params.dig(:pagination, :per_page) || default_per_page).to_i
  end

  def paginate_offset
    (current_page - 1) * per_page
  end

  def paginate
    -> (it) {
      @items_count = it.count(:id)
      @pages_count = (items_count / per_page.to_f).ceil
      items = it.limit(per_page).offset(paginate_offset)
      items = ActiveModel::Serializer::CollectionSerializer.new(items, serializer: serializer) if serializer.present?
      items
    }
  end

  def pagination
    { pages_count: pages_count, per_page: per_page, current_page: current_page, items_count: items_count }
  end
end
