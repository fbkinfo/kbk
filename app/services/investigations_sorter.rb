class InvestigationsSorter < Sorter
  sort_with 'investigations.title', 'investigations.created_at', 'closed_at'
  sort_with_default 'latest_document', 'desc'

  def apply(scope)
    sort_scope(scope) do |s, c, d|
      s.order("documents.created_at #{d}") if c == 'latest_document'
    end
  end
end
