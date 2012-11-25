# -*- encoding : utf-8 -*-
require "spec_helper"

describe Dictionary do
  describe "ignore" do
    context "when the given word is not included in ignored_words list" do
      it "adds the word to ignored_words"

      context "for each book" do
        it "calls Book#ignore with given word"
      end

      context "and the word is already in enries" do
        it "removes the corresponding entry"
      end
    end

    context "when the given word is already in ignored_words list" do
      context "for each book" do
        it "does not call Book#ignore"
      end
    end
  end
end