class InvestigationDecorator < Draper::Decorator
  delegate_all

  def description
    return if object.description.blank?

    description = anchorize_document_url

    markdown = RDiscount.new(description)
    h.auto_link markdown.to_html
  end

  private

  def anchorize_document_url
    object.description.gsub(/\/documents\/([\d]+)/) do
      document_id = $1
      investigation_id = Document.unscoped.find(document_id).investigation_id
      "/investigations/#{investigation_id}#document_#{document_id}"
    end
  end
end
