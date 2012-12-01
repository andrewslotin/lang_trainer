# -*- encoding : utf-8 -*-
require "spec_helper"

describe Entry do
  subject { FactoryGirl.build :entry_with_variants }
  let(:chapter) do
    chapter = FactoryGirl.build :chapter
    chapter.entries << subject

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
      let!(:orig_word) { subject.word }
      let!(:new_word) { "#{subject.word}updated" }

      before do
        subject.word = new_word
      end

      it "stores the original value in 'variants' on save" do
        subject.save!

        expect(subject.variants).to include orig_word
      end

      context "when the original value is already in 'variants'" do
        before do
          subject.variants << orig_word
        end

        it "does not store duplicate value" do
          expect { subject.save! }.not_to change { subject.variants }
        end
      end

      context "when the new value is already in 'variants'" do
        before do
          subject.variants = [new_word]
        end

        it "removes this variant" do
          expect { subject.save! }.to change { subject.variants }.to [orig_word]
        end
      end
    end
  end

  describe "merge" do
    let(:another_entry) { FactoryGirl.build :entry_with_variants, word: subject.word }

    it "increments the existing entry frequency by the frequency of passed one" do
      expect { subject.merge another_entry }.to change { subject.frequency }.by another_entry.frequency
    end

    it "updates the existing entry variants with variants of passed one" do
      subject.merge another_entry

      expect(subject.variants).to match_array (subject.variants + another_entry.variants - [another_entry.word]).uniq
    end

    it "appends notes from the given entry to notes of existing one" do
      subject.notes = "aaa"
      another_entry.notes = "bbb"

      expect { subject.merge another_entry }.to change { subject.notes }.to "aaa\nbbb"
    end
  end
end