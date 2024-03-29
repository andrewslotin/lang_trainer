# -*- encoding : utf-8 -*-
require "spec_helper"

describe Dictionary do
  subject { FactoryGirl.create :dictionary }
  let(:entry) { FactoryGirl.build :entry_with_variants }

  describe "<<" do
    shared_examples_for "merging existing entries" do
      before do
        subject.entries << existing_entry
      end

      it "does not add an entry to collection" do
        expect { subject << entry }.not_to change { subject.entries }
      end

      it "merges the passed entry with an existing one" do
        existing_entry.should_receive(:merge).with(entry).once

        subject << entry
      end
    end

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

      it_should_behave_like "merging existing entries"
    end

    context "when there is an entry with the same word in variants" do
      let(:existing_entry) { FactoryGirl.build :entry_with_variants, variants: [entry.word] }

      before do
        subject.entries << existing_entry
      end

      context "when the given entry has an existing_entry.word as a variant" do
        before do
          entry.variants << existing_entry.word
        end

        it_should_behave_like "merging existing entries" do
          it "should not put that variant to existing_entry.variants" do
            subject << entry

            expect(existing_entry.variants).not_to include existing_entry.word
          end
        end
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