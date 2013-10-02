require 'spec_helper'

describe DocumentsController do
  describe "destroy action" do
    context "under lawyer role" do
      it "user can't delete record of another user" do
        document = create(:document, response: create(:document))

        putin = create(:user)
        sign_in putin

        delete :destroy, id: document.id

        expect(document.reload.deleted_at).to be_nil
      end

      it "document without response can be destroyed by author" do
        document = create(:document)

        sign_in document.user

        delete :destroy, id: document.id

        expect(document.reload.deleted_at).to be_present
      end

      it "document with response can't be destroyed by author" do
        document = create(:document, response: create(:document))

        sign_in document.user

        delete :destroy, id: document.id

        expect(document.reload.deleted_at).to be_nil
      end
    end

    context "under admin role" do
      let(:admin) { create(:user, role: 'admin') }

      it "user can delete record with response" do
        document = create(:document)

        sign_in admin

        delete :destroy, id: document.id

        expect(document.reload.deleted_at).to be_present
      end

      it "document with response can't be destroyed" do
        document = create(:document, response: create(:document))

        sign_in admin

        delete :destroy, id: document.id

        expect(document.reload.deleted_at).to be_nil
      end
    end
  end

  describe "create action" do
    before do
      user = create(:user)
      sign_in user
    end

    it "new record is created" do
      investigation = create(:investigation)
      organization = create(:organization)
      snapshot = create(:snapshot)
      attachement = create(:document_attachement)

      expect {
        post :create, document: {
          title: "Stub",
          description: "stub",
          investigation_id: investigation.id,
          organization_id: organization.id,
          snapshot_ids: [snapshot.id],
          attachement_ids: [attachement.id]
        }
      }.to change(Document, :count).by(1)

      expect(snapshot.reload.document_id).to be_present
      expect(attachement.reload.document_id).to be_present

      expect(response.status).to eq(302)
    end
  end

  describe "update action" do
    context "being authorized user" do
      before do
        user = create(:user)
        sign_in user
      end

      it "existing record is updated" do
        document = create(:document)

        post :update, id: document.id, document: {
          title: "New title"
        }

        expect(document.reload.title).to eq "New title"
        expect(response).to redirect_to(document_path(document))
      end
    end

    context "being anonymous" do
      it "access is denied" do
        document = create(:document)

        post :update, id: document.id, document: {
          title: "New title"
        }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "index action" do
    context "being anonymous" do
      it "access is denied" do
        get :index

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "new action" do
    context "being anonymous" do
      it "access is denied" do
        get :new

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "edit action" do
    context "being anonymous" do
      it "access is denied" do
        document = create(:document)
        get :edit, id: document.id

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "create action" do
    context "being anonymous" do
      it "access is denied" do
        post :create, document: {
          title: "New title"
        }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "show action" do
    context "being anonymous" do
      context "with not published document" do
        it "access is denied" do
          document = create(:document)
          get :show, id: document.id

          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "with published document" do
        it "can read document" do
          document = create(:document, :published)
          get :show, id: document.id

          expect(response).to be_success
        end

        it "can't read document if it was not published yet" do
          investigation = create(:investigation, :published)
          document = create(:document, document_date: 3.days.since)
          get :show, id: document.id

          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end
  end

end
