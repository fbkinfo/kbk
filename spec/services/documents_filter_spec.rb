require 'spec_helper'

describe DocumentsFilter do
  it "can filter by user_id" do
    document = create(:document)
    filter = described_class.new({user_id: document.user_id}, [])
    results = filter.apply

    expect(results.size).to eq 1
    expect(results[0]).to eq document

    expect(filter.counters.total).to eq 1
  end

  it "can filter by favourites" do
    documents = create_list(:document, 2)

    filter = described_class.new({props: %w(marked)}, [documents[0].id])
    results = filter.apply

    expect(results.size).to eq 1
    expect(results[0]).to eq documents[0]

    expect(filter.counters.total).to eq 1
  end

  it "can filter expired" do
    create(:document, due_date: Date.tomorrow)
    document = create(:document, due_date: Date.yesterday)

    filter = described_class.new({props: %w(expired)}, [])
    results = filter.apply

    expect(results.size).to eq 1
    expect(results[0]).to eq document

    expect(filter.counters.total).to eq 1
  end

  it "can filter with_due_date" do
    create(:document, due_date: nil)
    document = create(:document, due_date: Date.yesterday)

    filter = described_class.new({with_due_date: '1'}, [])
    results = filter.apply

    expect(results.size).to eq 1
    expect(results[0]).to eq document

    expect(filter.counters.total).to eq 1
  end

  it "can filter with no_answer" do
    without_response = create(:document)
    create(:document, response: without_response)

    filter = described_class.new({props: %w(no_answer)}, [])
    results = filter.apply

    expect(results.size).to eq 1
    expect(results[0]).to eq without_response

    expect(filter.counters.total).to eq 1
  end
end
