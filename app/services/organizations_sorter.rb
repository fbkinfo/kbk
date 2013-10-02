class OrganizationsSorter < Sorter
  sort_with 'name', 'documents_count', 'investigations_count', 'created_at'
end
