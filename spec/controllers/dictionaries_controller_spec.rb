# -*- encoding : utf-8 -*-
require "spec_helper"

describe DictionariesController do
  let(:user) { FactoryGirl.create :twitter_user }
  let!(:dictionary) { FactoryGirl.create :dictionary, user: user }

  before do
    Dictionary.stub(:find).and_return dictionary
    subject.stub(:current_user).and_return user
  end

  describe "ignore" do
    before do
      request.env["HTTP_REFERER"] = dictionaries_path
    end

    shared_examples_for "redirecting back" do
      it "should redirect back" do
        post :ignore, id: dictionary._id

        expect(response).to redirect_to dictionaries_path
      end
    end

    it_should_behave_like "redirecting back"

    context "when the param[:word] is not set" do
      it_should_behave_like "redirecting back"
    end

    context "when the param[:word] is set" do
      let(:word) { "the" }

      it_should_behave_like "redirecting back"

      it "should call Dictionary#ignore_word with params[:word]" do
        dictionary.should_receive :ignore_word, with: word

        post :ignore, id: dictionary._id, word: word
      end
    end
  end
end