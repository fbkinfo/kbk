require 'spec_helper'

describe InvestigationsController do
  describe "#index" do
    context "under authorozed user" do
      it "doesn't display deleted records" do
        deleted_investigation = create(:investigation, deleted_at: Date.current)

        sign_in deleted_investigation.user

        get :index

        expect(response).to be_success

        expect(assigns(:investigations)).not_to include(deleted_investigation)
      end
    end

    context "being anonymous" do
      it "can read the list" do
        get :index

        expect(response).to be_success
      end

      it "doesn't contain unpublished investigations" do
        investigation = create(:investigation)
        published = create(:investigation, :published)

        get :index

        expect(assigns(:investigations)).to include(published)
        expect(assigns(:investigations)).not_to include(investigation)
      end
    end
  end

  describe "#destroy" do
    context "under lawyer role" do
      it "user can delete his own record" do
        investigation = create(:investigation)

        sign_in investigation.user

        delete :destroy, id: investigation.id

        expect(investigation.reload.deleted_at).to be_present
      end

      it "user can't delete record of another user" do
        investigation = create(:investigation)

        putin = create(:user)
        sign_in putin

        delete :destroy, id: investigation.id

        expect(investigation.reload.deleted_at).to be_nil
      end
    end

    context "under admin role" do
      let(:admin) { create(:user, role: 'admin') }

      it "user can delete any record" do
        investigation = create(:investigation)

        sign_in admin

        delete :destroy, id: investigation.id

        expect(investigation.reload.deleted_at).to be_present
      end
    end

    context "being anonymous" do
      it "access is denied" do
        investigation = create(:investigation)

        delete :destroy, id: investigation.id

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "#publish" do
    context "being anonymous" do
      it "access is denied" do
        investigation = create(:investigation)

        put :publish, id: investigation.id

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "under authorozed user" do
      it "investigation is published" do
        investigation = create(:investigation)
        expect(investigation.publish.active?).to be_false
        sign_in investigation.user

        put :publish, id: investigation.id, date: '2013-05-03'

        expect(response).to redirect_to(investigation_path(investigation))
        expect(investigation.reload.publish.active?).to be_true
      end
    end
  end

  describe "#unpublish" do
    context "being anonymous" do
      it "access is denied" do
        investigation = create(:investigation)

        put :unpublish, id: investigation.id

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "under authorozed user" do
      it "investigation is published" do
        investigation = create(:investigation, published_until: Date.yesterday)
        expect(investigation.publish.active?).to be_true
        sign_in investigation.user

        put :unpublish, id: investigation.id

        expect(response).to redirect_to(investigation_path(investigation))
        expect(investigation.reload.publish.active?).to be_false
      end
    end
  end

  describe "#update" do
    context "being anonymous" do
      it "access is denied" do
        investigation = create(:investigation)

        post :update, id: investigation.id, investigation: {
          title: "New title"
        }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "#new" do
    context "being anonymous" do
      it "access is denied" do
        get :new

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "#edit" do
    context "being anonymous" do
      it "access is denied" do
        document = create(:document)
        get :edit, id: document.id

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "#create" do
    context "being anonymous" do
      it "access is denied" do
        post :create, investigation: {
          title: "New title"
        }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "#show" do
    context "being anonymous" do
      context "with not published investigation" do
        it "access is denied" do
          investigation = create(:investigation)
          get :show, id: investigation.id

          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "with published investigation" do
        it "can read investigation" do
          investigation = create(:investigation, :published)
          get :show, id: investigation.id

          expect(response).to be_success
        end
      end
    end
  end

end
