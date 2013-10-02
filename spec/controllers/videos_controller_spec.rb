require 'spec_helper'

describe VideosController do
  describe "#destroy" do
    context "under authorized user" do
      it "video can be destroyed" do
        video = create(:video)

        sign_in video.investigation.user

        expect {
          delete :destroy, id: video.id
        }.to change(Video, :count).by(-1)
      end
    end

    context "under anonymous" do
      it "access is denied" do
        video = create(:video)

        expect {
          delete :destroy, id: video.id
        }.not_to change(Video, :count)
      end
    end
  end


  describe "#create" do
    context "under authorized user" do
      it "new record is created" do
        investigation = create(:investigation)

        sign_in investigation.user

        expect {
          post :create, video: {
            body: "some url",
            entry_date: Date.current.to_s,
            investigation_id: investigation.id
          }
        }.to change(Video, :count).by(1)

        expect(response.status).to eq(302)
      end
    end

    context "under anonymous" do
      it "access is denied" do
        investigation = create(:investigation)

        expect {
          post :create, video: {
            body: "some url",
            entry_date: Date.current.to_s,
            investigation_id: investigation.id
          }
        }.not_to change(Video, :count)
      end
    end
  end
end
