# -*- encoding : utf-8 -*-
require "spec_helper"

describe Dictionary do
  subject { FactoryGirl.create :dictionary }

  describe "ignore_word" do
    let(:word) { "the" }
    let(:entry) { FactoryGirl.build :entry, word: word }

    context "when the given word is not included in ignored_words list" do
      it "adds the word to ignored_words" do
        subject.ignore_word word

        expect(subject.reload.ignored_words).to include word
      end

      context "for each book" do
        let(:books) do
          (0...3).map { |i| FactoryGirl.create :book, dictionary: subject }
        end

        it "calls Book#ignore_word with given word" do
          books.each do |book|
            book.should_receive :ignore_word, with: word
          end

          subject.ignore_word word
        end
      end

      context "and the word is already in entries" do
        before do
          subject.entries = [entry]
        end

        it "removes the corresponding entry" do
          subject.ignore_word word

          expect(subject.reload.entries).not_to include entry
        end
      end
    end

    context "when the given word is already in ignored_words list" do
      it "does not add the word to ignored_words"

      context "for each book" do
        it "does not call Book#ignore_word"
      end
    end
  end
end