class DocumentsFilter < Filter
  class Counters < Struct.new(:total, :incoming, :outgoing);end

  filter_with 'kind', 'investigation_id', 'organization_id', 'author_id'

  def initialize(filter_params, favourite_ids)
    @favourite_ids = favourite_ids
    @scope = Document.includes(:author, :investigation, :organization, :response)

    @filterer = F.new(filter_params)
  end

  private

  def apply_filters
    @scope = filter_scope(@scope) do |s, f|
      s = s.textual(f.title) if f.title.present?
      s = s.without_response if f.props.try(:include?, 'no_answer')
      s = s.where(id: @favourite_ids) if f.props.try(:include?, 'marked')
      s = s.expired if f.props.try(:include?, 'expired')
      s = s.with_due_date if f.with_due_date == '1'
      s = s.where(user_id: f.user_id) if f.user_id.present?

      s = f.class.filter_by_dates_or_period(s, f.creation_period, f.creation_from, f.creation_to) do |p|
        {created_at: p}
      end

      f.class.filter_by_dates_or_period(s, f.period, f.date_from, f.date_to) do |p|
        {document_date: p}
      end
    end
  end

  def apply_counters
    @counters = Counters.new(@scope.count(true), @scope.incoming.count(true), @scope.outgoing.count(true))
  end
end
