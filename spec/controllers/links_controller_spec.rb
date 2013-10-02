require 'spec_helper'

describe LinksController do
  describe "#destroy" do
    context "under authorized user" do
      it "link can be destroyed" do
        link = create(:link)

        sign_in link.investigation.user

        expect {
          delete :destroy, id: link.id
        }.to change(Link, :count).by(-1)
      end
    end

    context "under anonymous" do
      it "access is denied" do
        link = create(:link)

        expect {
          delete :destroy, id: link.id
        }.not_to change(Link, :count)
      end
    end
  end


  describe "#create" do
    context "under authorized user" do
      it "new record is created" do
        investigation = create(:investigation)

        sign_in investigation.user

        expect {
          post :create, link: {
            title: "some url",
            comment: "some comment",
            url: "http://yandex.ru",
            entry_date: Date.current.to_s,
            investigation_id: investigation.id
          }
        }.to change(Link, :count).by(1)

        expect(response.status).to eq(302)
      end
    end

    context "under anonymous" do
      it "access is denied" do
        investigation = create(:investigation)

        expect {
          post :create, link: {
            title: "some url",
            comment: "some comment",
            url: "http://yandex.ru",
            entry_date: Date.current.to_s,
            investigation_id: investigation.id
          }
        }.not_to change(Link, :count)
      end
    end
  end
end
