require 'spec_helper'

require 'concerns/with_timeline_entry'

class TimelineMeeting < ActiveRecord::Base
  include WithTimelineEntry

  belongs_to :investigation
end

describe WithTimelineEntry do
  before(:all) do
    ActiveRecord::Base.connection.create_table :timeline_meetings do |t|
      t.date :entry_date
      t.string :title
      t.references :investigation
    end
  end

  after(:all) do
    ActiveRecord::Base.connection.drop_table :timeline_meetings
  end

  context "timelined model" do
    let(:investigation) { create(:investigation) }
    let(:meeting) { TimelineMeeting.create!(entry_date: Date.current, investigation: investigation) }

    it "has timeline entry after create" do
      expect(meeting.timeline_entry).to be_present

      expect(meeting.timeline_entry.resource).to eq meeting
      expect(meeting.timeline_entry.investigation).to eq meeting.investigation
      expect(meeting.timeline_entry.entry_date).to eq meeting.entry_date
    end

    it "updates timeline entry on entry_date change" do
      new_date = meeting.entry_date - 2.days
      meeting.update(entry_date: new_date)

      expect(meeting.timeline_entry.entry_date).to eq new_date
    end

    it "removes timeline entry on destroy" do
      expect(meeting.timeline_entry).to be_present

      expect {
        meeting.destroy
      }.to change(TimelineEntry, :count).by(-1)
    end

    context "empty investigation" do
      it "updates investigation later" do
        meeting = TimelineMeeting.create!(entry_date: Date.current)
        expect(meeting.timeline_entry).to be_nil

        new_date = 4.days.ago.to_date
        meeting.update(investigation: investigation, entry_date: new_date)
        expect(meeting.timeline_entry).to be_present
        expect(meeting.timeline_entry.investigation).to eq investigation
        expect(meeting.timeline_entry.entry_date).to eq new_date

        latest_date = Date.yesterday
        meeting.update(entry_date: latest_date)
        expect(meeting.timeline_entry.entry_date).to eq latest_date
      end
    end
  end
end
