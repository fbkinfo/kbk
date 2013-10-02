require 'spec_helper'

describe FavouritesController do
  context "being authorized user" do
    before do
      sign_in create(:user)
    end

    context "with existing resource" do
      it "adds to favourites" do
        document = create(:document)

        expect {
          post :create, document_id: document
        }.to change(Favourite, :count).by(1)
      end

      it "removes to favourites" do
        document = create(:document)

        post :create, document_id: document

        expect {
          delete :destroy, document_id: document
        }.to change(Favourite, :count).by(-1)
      end
    end
  end
end