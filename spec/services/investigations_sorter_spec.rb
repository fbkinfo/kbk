require 'spec_helper'

describe InvestigationsSorter do
  it "sorts by investigations.title" do
    sql = sort_by('investigations.title')
    expect(sql).to include "ORDER BY investigations.title desc"
  end

  it "sorts by closed_at" do
    sql = sort_by('closed_at')
    expect(sql).to include "ORDER BY closed_at desc"
  end

  it "sorts by investigations.created_at" do
    sql = sort_by('investigations.created_at')
    expect(sql).to include "ORDER BY investigations.created_at desc"
  end

  it "doesn't sort by unknown column" do
    sql = sort_by('putinvor')
    expect(sql).not_to include "ORDER BY"
  end

  def sort_by(column)
    params = { column: column, direction: 'desc' }
    scope = described_class.new(params).apply(Document.all)
    scope.to_sql
  end
end
