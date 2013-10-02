require 'spec_helper'

describe SnapshotDecorator do
  describe "#scan" do
    context "being anonymous user" do
      context "with public scan uploaded" do
        it "returns public scan" do
          snapshot = create(:snapshot)
          snapshot.public_scan = snapshot.original_scan
          snapshot.save!

          decorator = described_class.new(snapshot)
          decorator.h.stub(:user_signed_in?).and_return(false)

          expect(decorator.scan).to eq(snapshot.public_scan)
        end
      end

      context "with no public scan uploaded" do
        it "returns original scan" do
          snapshot = create(:snapshot)
          decorator = described_class.new(snapshot)
          decorator.h.stub(:user_signed_in?).and_return(false)

          expect(decorator.scan).to eq(snapshot.original_scan)
        end
      end
    end

    context "being authorized user" do
      it "returns original scan" do
        snapshot = create(:snapshot)
        decorator = described_class.new(snapshot)
        decorator.h.stub(:user_signed_in?).and_return(true)

        expect(decorator.scan).to eq(snapshot.original_scan)
      end
    end
  end
end
