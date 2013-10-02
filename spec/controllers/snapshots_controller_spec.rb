require 'spec_helper'

describe SnapshotsController do
  describe "#destroy" do
    context "being anonymous" do
      it "access is denied" do
        snapshot = create(:snapshot)

        expect {
          delete :destroy, id: snapshot.id
        }.not_to change(Snapshot, :count)
      end
    end

    context "being authorized user" do
      before do
        sign_in create(:user)
      end

      it "can delete record" do
        snapshot = create(:snapshot)

        expect {
          delete :destroy, id: snapshot.id
        }.to change(Snapshot, :count).by -1
      end
    end
  end

  describe "#create" do
    context "being anonymous" do
      it "access is denied" do
        post :create

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "being authorized user" do
      let(:scan) {
        fixture_file_upload('/homer.jpg', 'image/jpeg')
      }

      before do
        sign_in create(:user)
      end

      context "for existing document" do
        it "snapshot is created" do
          document = create(:document)

          expect {
            post :create, document_id: document.id, file: scan
          }.to change(Snapshot, :count).by(1)

          expect(response).to be_success
          expect(Snapshot.last.document_id).to eq(document.id)
          response.should render_template("documents/_snapshot")
        end
      end

      context "for new document" do
        it "snapshot is created" do
          expect {
            post :create, file: scan
          }.to change(Snapshot, :count).by(1)

          expect(response).to be_success
          expect(Snapshot.last.document_id).to be_nil
          response.should render_template("documents/_snapshot")
        end
      end
    end
  end

  describe "#update" do
    context "being authorized user" do
      before do
        sign_in create(:user)
      end

      it "can upload public scan" do
        snapshot = create(:snapshot)
        expect(snapshot.public_scan).to be_blank

        base64_image = File.open(Rails.root.join("spec/fixtures/base64_image")).read
        post :update, format: :json, id: snapshot.id, snapshot: {
          public_scan: base64_image
        }

        expect(response).to be_success
        expect(snapshot.reload.public_scan).to be_present
      end
    end

    context "being anonymous" do
      it "access is denied" do
        snapshot = create(:snapshot)

        post :update, format: :json, id: snapshot.id, snapshot: {
          public_scan: "some bad data"
        }

        expect(response.status).to eq 401
      end
    end
  end

  describe "#sort" do
    context "being authorized user" do
      before do
        sign_in create(:user)
      end

      it "can sort records" do
        document = create(:document)
        snapshots = create_list(:snapshot, 3, document: document)
        post :sort, snapshot: snapshots.map(&:id)

        snapshots.each(&:reload)
        expect(snapshots.map(&:number)).to eq [1, 2, 3]
      end
    end

    context "being anonymous" do
      it "access is denied" do
        post :sort, snapshot: [1, 2, 3]

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
