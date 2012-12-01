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
      let!(:new_word) { "#{entry.word}updated" }

      before do
        entry.word = new_word
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

      context "when the new value is already in 'variants'" do
        before do
          entry.variants = [new_word]
        end

        it "removes this variant" do
          expect { entry.save! }.to change { entry.variants }.to [orig_word]
        end
      end
    end
  end
end