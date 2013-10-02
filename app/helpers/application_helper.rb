module ApplicationHelper
  def sort_by(column)
    return 'javascript:;' unless defined?(@sorter)
    direction = @sorter.direction == 'asc' ? 'desc' : 'asc'

    filter = @filter.try(:filterer).blank? ? nil : @filter.filterer.marshal_dump

    url_for(f: filter, s: {column: column, direction: direction})
  end

  def sort_class?(column)
    return "" unless defined?(@sorter) && column == @sorter.column
    "is-sorted #{@sorter.direction}"
  end

  def star(entity, url, checked=false)
    content_tag :div, class: 'toggle-star' do
      content_tag :label do
        check_box_tag('starred', entity.id, checked, role: 'star', 'data-url' => url) +
        (content_tag(:div, class: 'toggle-star-icon') {})
      end
    end
  end
end
