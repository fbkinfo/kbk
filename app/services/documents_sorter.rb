class DocumentsSorter < Sorter
  sort_with 'title', 'documents.created_at', 'documents.document_date', 'due_date'
  sort_with_default 'documents.created_at', 'desc'

  def apply(scope)
    sort_scope(scope) do |s, c, d|
      case c
      when 'organization'
        s.order("organizations.name #{d}")
      when 'investigation'
        s.order("investigations.title #{d}")
      when 'author'
        s.order("authors.name #{d}")
      end
    end
  end
end
