class InvestigationsFilter < Filter
  class Counters < Struct.new(:total);end

  filter_with 'status'

  def initialize(filter_params, user, favourite_ids)
    @favourite_ids = favourite_ids
    @user = user
    @scope = Investigation.includes(:latest_document, :organizations)

    @filterer = F.new(filter_params)
  end

  private

  def apply_filters
    @scope = filter_scope(@scope) do |s, f|
      s = s.textual(f.title) if f.title.present?
      s = s.where(id: @favourite_ids) if f.props.try(:include?, 'marked')
      s = s.where(organizations: {id: f.organization_id}) if f.organization_id.present?
      s = s.where(documents: {response_id: nil}) if f.props.try(:include?, 'no_answer')
      s = s.published if f.props.try(:include?, 'published')
      s = s.where(project_kind: f.project_kind) if f.project_kind.present?

      if @user.investigations.any? && f.user_id.nil?
        f.user_id = @user.id
      end
      s = s.where(user_id: f.user_id) if f.user_id.present?

      s = f.class.filter_by_dates_or_period(s,
        f.creation_period,
        f.creation_date_from,
        f.creation_date_to
      ) do |p|
        {created_at: p}
      end

      f.class.filter_by_dates_or_period(s,
        f.latest_document_period,
        f.latest_document_date_from,
        f.latest_document_date_to
      ) do |p|
        {documents: {created_at: p}}
      end
    end
  end

  def apply_counters
    @counters = Counters.new(@scope.count(true))
  end
end
