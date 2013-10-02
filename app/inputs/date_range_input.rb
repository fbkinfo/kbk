class DateRangeInput < SimpleForm::Inputs::Base
  def input
    from_attribute_name = (attribute_name.to_s + '_from').to_sym
    to_attribute_name   = (attribute_name.to_s + '_to').to_sym

    out = ''
    out += template.content_tag :div, class: 'date-selector', role: 'date_selector' do
      @builder.input attribute_name, as: :custom_select, collection: I18n.t('date_range.options').invert, label: false, required: false
    end

    out += template.content_tag :div, class: 'date-range-picker', role: 'date_range_picker' do
      @builder.input(from_attribute_name, as: :datepicker, required: false, label: false) +
      @builder.input(to_attribute_name, as: :datepicker, required: false, label: false) +
      template.link_to('x', '#', class: 'date-range-picker-close', role: 'date_range_picker_close')

    end
    out.html_safe
  end
end

