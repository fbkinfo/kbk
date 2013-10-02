require 'spec_helper'
require 'concerns/safe_destroy'

class DeletableMeeting < ActiveRecord::Base
  include SafeDestroy
end

describe SafeDestroy do
  before(:all) do
    ActiveRecord::Base.connection.create_table :deletable_meetings do |t|
      t.datetime :deleted_at
    end
  end

  after(:all) do
    ActiveRecord::Base.connection.drop_table :deletable_meetings
  end


  describe "scopes" do
    before do
      @meeting = DeletableMeeting.create
      @deleted_meeting = DeletableMeeting.create(deleted_at: Date.current)
    end

    it "deleted scope include only deleted entries" do
      deleted_ids = DeletableMeeting.unscoped.deleted.pluck(:id)
      expect(deleted_ids).to include(@deleted_meeting.id)
      expect(deleted_ids).not_to include(@meeting.id)
    end

    it "not_deleted scope include only actual entries" do
      deleted_ids = DeletableMeeting.not_deleted.pluck(:id)
      expect(deleted_ids).not_to include(@deleted_meeting.id)
      expect(deleted_ids).to include(@meeting.id)
    end
  end

  describe "safe_destroy method" do
    it "deletes record" do
      meeting = DeletableMeeting.create
      expect(meeting.deleted_at).to be_nil

      meeting.safe_destroy
      expect(meeting.deleted_at).to be_present
    end

    context "with timeline entry" do
      it "deletes timeline entry" do
        meeting = DeletableMeeting.create

        timeline = double
        expect(timeline).to receive(:destroy).once
        allow(meeting).to receive(:timeline_entry).and_return(timeline)

        meeting.safe_destroy
      end
    end
  end
end