class DatepickerInput < SimpleForm::Inputs::Base
  def input
    value = object.try(attribute_name)
    value = value.strftime("%d.%m.%Y") if value.respond_to?(:strftime)

    @builder.text_field(attribute_name, input_html_options.merge(
      role: 'datepicker',
      value: value
    ))
  end
end

