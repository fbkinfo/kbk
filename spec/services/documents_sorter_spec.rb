require 'spec_helper'

describe DocumentsSorter do
  it "sorts by documents.document_date" do
    sql = sort_by('documents.document_date')
    expect(sql).to include "ORDER BY documents.document_date desc"
  end

  it "sorts by due_date" do
    sql = sort_by('due_date')
    expect(sql).to include "ORDER BY due_date desc"
  end

  it "sorts by documents.created_at" do
    sql = sort_by('documents.created_at')
    expect(sql).to include "ORDER BY documents.created_at desc"
  end

  it "doesn't sort by unknown column" do
    sql = sort_by('putinvor')
    expect(sql).not_to include "ORDER BY"
  end

  it "sorts by organization" do
    sql = sort_by('organization')
    expect(sql).to include "ORDER BY organizations.name desc"
  end

  it "sorts by author" do
    sql = sort_by('author')
    expect(sql).to include "ORDER BY authors.name desc"
  end

  it "sorts by investigation" do
    sql = sort_by('investigation')
    expect(sql).to include "ORDER BY investigations.title desc"
  end

  def sort_by(column)
    params = { column: column, direction: 'desc' }
    scope = described_class.new(params).apply(Document.all)
    scope.to_sql
  end
end
