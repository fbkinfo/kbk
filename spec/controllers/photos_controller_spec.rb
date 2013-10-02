require 'spec_helper'

describe PhotosController do
  describe "#destroy" do
    context "under authorized user" do
      it "photo can be destroyed" do
        photo = create(:photo)

        sign_in photo.investigation.user

        expect {
          delete :destroy, id: photo.id
        }.to change(Photo, :count).by(-1)
      end
    end

    context "under anonymous" do
      it "access is denied" do
        photo = create(:photo)

        expect {
          delete :destroy, id: photo.id
        }.not_to change(Photo, :count)
      end
    end
  end

  describe "#finalize" do
    context "under authorized user" do
      it "photos are updated" do
        investigation = create(:investigation)
        photos = create_list(:photo, 2, investigation: investigation)

        sign_in investigation.user

        new_date = Date.new(2013, 9, 9)

        # mock referer for redirect_to :back
        request.env["HTTP_REFERER"] = "/investigations/#{investigation.id}"
        post :finalize, photo: photos.map { |ph| {id: ph.id, investigation_id: investigation.id, comment: "new comment for #{ph.id}", entry_date: new_date.to_s } }

        expect(response).to redirect_to(investigation)

        photos.each do |photo|
          expect(photo.reload.comment).to eq "new comment for #{photo.id}"
          expect(photo.reload.entry_date).to eq new_date
          expect(photo.reload.investigation_id).to eq investigation.id
        end
      end
    end

    context "under anonymous" do
      it "access is denied" do
        investigation = create(:investigation)
        photos = create_list(:photo, 2, investigation: investigation)

        post :finalize, photo: photos.map { |ph| {id: ph.id, comment: "new comment for #{ph.id}"} }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "#create" do
    context "under authorized user" do
      it "new record is created" do
        investigation = create(:investigation)

        sign_in investigation.user

        expect {
          post :create,
            image: fixture_file_upload('/homer.jpg', 'image/jpeg'),
            entry_date: Date.current.to_s,
            investigation_id: investigation.id
        }.to change(Photo, :count).by(1)

        response.should render_template("investigations/modals/_photo_form_block")
      end
    end

    context "under anonymous" do
      it "access is denied" do
        investigation = create(:investigation)

        expect {
          post :create, photo: {
            body: "some url",
            entry_date: Date.current.to_s,
            investigation_id: investigation.id
          }
        }.not_to change(Photo, :count)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end