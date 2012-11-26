# -*- encoding : utf-8 -*-
require "spec_helper"

describe Chapter do
  let(:word) { "the" }

  describe "ignore_word" do
    context "when there is an entry for given word" do
      subject do
        book = FactoryGirl.create :book
        chapter = FactoryGirl.build :chapter_with_entries
        book.chapters = [chapter]
        book.save!

        chapter
      end
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
      it "decrements the number of words in chapter by the entry frequency"
    end
  end
end