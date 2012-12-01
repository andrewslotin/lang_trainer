# -*- encoding : utf-8 -*-
require "spec_helper"

describe Dictionary do
  subject { FactoryGirl.create :dictionary }
  let(:entry) { FactoryGirl.build :entry_with_variants }

  describe "<<" do
    context "when the given entry.word is in 'ignored_words' list" do
      before do
        subject.ignored_words << entry.word
      end

      it "does not add the entry to collection" do
        expect { subject << entry }.not_to change { subject.entries }
      end
    end

    context "when there is an entry with the same word in 'entries'" do
      let(:existing_entry) { FactoryGirl.build :entry_with_variants, word: entry.word }
      before do
        subject.entries << existing_entry
      end

      it "does not add an entry to collection" do
        expect { subject << entry }.not_to change { subject.entries }
      end

      it "increments the existing entry frequency by the frequency of passed one" do
        expect { subject << entry }.to change { existing_entry.frequency }.by entry.frequency
      end

      it "updates the existing entry variants with variants of passed one" do
        subject << entry

        expect(existing_entry.variants).to match_array (entry.variants + existing_entry.variants).uniq
      end
    end

    it "adds the passed entry to 'entries' collection" do
      expect { subject << entry }.to change { subject.entries.collect(&:word) }.to [entry.word]
    end
  end

  describe "ignore_word" do
    let(:word) { "the" }
    let(:entry) { FactoryGirl.build :entry, word: word }
    let(:books) do
      (0...3).map { |i| FactoryGirl.create :book, dictionary: subject }
    end

    context "when the given word is not included in ignored_words list" do
      it "adds the word to ignored_words" do
        subject.ignore_word word

        expect(subject.reload.ignored_words).to include word
      end

      context "for each book" do
        it "calls Book#ignore_word with given word" do
          books.each do |book|
            book.should_receive(:ignore_word).with word
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
      before do
        subject.ignored_words = [word]
        subject.save
      end

      it "does not add the word to ignored_words" do
        subject.ignore_word word

        expect(subject.reload.ignored_words).to eq [word]
      end

      context "for each book" do
        it "does not call Book#ignore_word" do
          books.each do |book|
            book.should_not_receive :ignore_word
          end

          subject.ignore_word word
        end
      end
    end
  end
end