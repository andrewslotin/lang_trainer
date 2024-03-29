# -*- encoding : utf-8 -*-
require "spec_helper"

describe Chapter do
  subject do
    book = FactoryGirl.create :book
    chapter = FactoryGirl.build :chapter_with_entries
    book.chapters = [chapter]
    book.save!

    chapter
  end

  let(:word) { "the" }

  describe "ignore_word" do
    context "when there is an entry for given word" do
      let(:entry) { FactoryGirl.build :entry, word: word }

      before do
        subject.entries << entry
        subject.words_number += entry.frequency

        subject.save!
      end

      it "removes this entry" do
        subject.ignore_word word

        expect(subject.entries).not_to include entry
      end

      it "decrements the number of words in chapter by the entry frequency" do
        words_number = subject.words_number
        subject.ignore_word word

        expect(subject.words_number).to eq words_number - entry.frequency
      end
    end

    context "when there is no entry for the given word" do
      it "doesn't change entries" do
        entries = subject.entries
        subject.ignore_word word

        expect(subject.entries).to eq entries
      end

      it "doesn't change words_number" do
        words_number = subject.words_number
        subject.ignore_word word

        expect(subject.words_number).to eq words_number
      end
    end
  end
end