class CustomSelectInput < SimpleForm::Inputs::CollectionSelectInput
  def input
    input_html_options.merge! role: 'custom_select'
    super
  end
end