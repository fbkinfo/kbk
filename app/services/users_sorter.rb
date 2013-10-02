class UsersSorter < Sorter
  sort_with 'name', 'email', 'documents_count', 'last_sign_in_at'
end
