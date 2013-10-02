require 'spec_helper'

describe InvestigationsFilter do
  let(:viewer) { create(:user) }

  it "can filter by user_id" do
    create(:investigation)

    investigation = create(:investigation)
    filter = described_class.new({user_id: investigation.user_id}, viewer, [])
    results = filter.apply

    expect(results.size).to eq 1
    expect(results[0]).to eq investigation

    expect(filter.counters.total).to eq 1
  end

  it "can filter by published" do
    create(:investigation)

    investigation = create(:investigation, :published)
    filter = described_class.new({props: %w(published)}, viewer, [])
    results = filter.apply

    expect(results.size).to eq 1
    expect(results[0]).to eq investigation

    expect(filter.counters.total).to eq 1
  end

  it "can filter by favourites" do
    investigations = create_list(:investigation, 2)

    filter = described_class.new({props: %w(marked)}, viewer, [investigations[0].id])
    results = filter.apply

    expect(results.size).to eq 1
    expect(results[0]).to eq investigations[0]

    expect(filter.counters.total).to eq 1
  end

  it "can filter by project_kind" do
    create(:investigation, project_kind: "investigation")

    investigation = create(:investigation, project_kind: "rospil")
    filter = described_class.new({project_kind: "rospil"}, viewer, [])
    results = filter.apply

    expect(results.size).to eq 1
    expect(results[0]).to eq investigation

    expect(filter.counters.total).to eq 1
  end
end
