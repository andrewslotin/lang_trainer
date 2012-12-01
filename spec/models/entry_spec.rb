# -*- encoding : utf-8 -*-
require "spec_helper"

describe Entry do
  let(:entry) { FactoryGirl.build :entry }
  let(:chapter) do
    chapter = FactoryGirl.build :chapter
    chapter.entries << entry

    chapter
  end
  let!(:book) do
    book = FactoryGirl.build :book
    book.chapters << chapter

    book.save!
    book
  end

  describe "before save" do
    context "when the 'word' was changed" do
      let!(:orig_word) { entry.word }
      before do
        entry.word = "#{entry.word}updated"
      end

      it "stores the original value in 'variants' on save" do
        entry.save!

        expect(entry.variants).to include orig_word
      end

      context "when the original value is already in 'variants'" do
        before do
          entry.variants = [orig_word]
        end

        it "does not store duplicate value" do
          expect { entry.save! }.not_to change { entry.variants }
        end
      end
    end
  end
end