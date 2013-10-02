require 'spec_helper'

describe Investigation do
  describe "being published" do
    subject { create(:investigation) }

    it "can be published by yesterday" do
      subject.publish.update(Date.yesterday)
      expect(subject.publish).to be_active
      expect(subject.published_until).to eq(Date.yesterday)
    end

    it "can not be published for earlier date" do
      subject.publish.update(Date.yesterday)
      subject.publish.update(3.days.ago.to_date)
      expect(subject.published_until).to eq(Date.yesterday)
    end

    it "can not be published by future" do
      subject.publish.update(Date.tomorrow)
      expect(subject.publish).not_to be_active
    end

    context "with string date" do
      it "can be published" do
        subject.publish.update(Date.current.to_s)
        expect(subject.published_until).to eq(Date.current)
      end
    end

    context "with blank date" do
      it "don't raise an error" do
        subject.publish.update("")
        expect(subject.published_until).to be_nil
      end
    end

    context "with invalid date" do
      it "don't raise an error" do
        subject.publish.update("xxxx-yyy-dddd")
        expect(subject.published_until).to be_nil
      end
    end

    context "already published" do
      it "can be unpublished" do
        investigation = create(:investigation, published_until: Date.yesterday)
        expect(investigation.publish).to be_active

        investigation.publish.cancel
        expect(investigation.publish).not_to be_active
      end
    end

    it "deleted record cannot be published" do
      investigation = Investigation.new(published_until: Date.tomorrow, deleted_at: Date.yesterday)

      expect(investigation.publish).not_to be_active
    end
  end
end
