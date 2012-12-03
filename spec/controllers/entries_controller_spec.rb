# -*- encoding : utf-8 -*-
require "spec_helper"

describe EntriesController do
  let(:user) { FactoryGirl.create :twitter_user }
  let!(:dictionary) { FactoryGirl.create :dictionary, user: user }
  let(:entry) { FactoryGirl.build :entry }
  let(:chapter) do
    chapter = FactoryGirl.build :chapter
    chapter.entries << entry

    chapter
  end
  let(:book) do
    book = FactoryGirl.create :book, dictionary: dictionary
    book.chapters << chapter

    book.save!
    book
  end
  let(:route_params) do
    {
      book_id:    book._id,
      chapter_id: chapter._id,
      id:         entry._id
    }
  end

  before do
    subject.stub(:current_user).and_return user
  end

  describe "ignore" do
    before do
      book.stub(:dictionary).and_return dictionary
      Book.stub(:find).with(book.id.to_s).and_return book
      book.stub_chain(:chapters, :find).with(chapter.id.to_s).and_return chapter
      chapter.stub_chain(:entries, :page, :find).with(entry.id.to_s).and_return entry
    end

    let(:referrer_address) { book_chapter_path(book, chapter) }

    before do
      request.env["HTTP_REFERER"] = referrer_address
      dictionary.stub! :ignore_word
    end

    it "should redirect back" do
      put :ignore, route_params

      expect(response).to redirect_to referrer_address
    end

    it "should call Dictionary#ignore_word with given Entry#word" do
      dictionary.should_receive(:ignore_word).with entry.word

      put :ignore, route_params
    end
    
  end

  describe "update" do
    let(:updated_word) { "#{entry.word}updated" }

    it "updates the word field" do
      put :update, route_params.update(entry: { word: updated_word })

      expect(entry.reload.word).to eq updated_word
    end

    context "when there is an existing entry with the same word" do
      let!(:existing_entry) do
        entry = FactoryGirl.build :entry
        chapter.entries << entry
        book.save!

        entry
      end
      let(:updated_word) { existing_entry.word }

      it "removes the entry" do
        expect {
          put :update, route_params.update(entry: { word: updated_word })
        }.to change { chapter.reload.entries.size }.by -1
      end
      it "updates the frequency of existing entry" do
        expect {
          put :update, route_params.update(entry: { word: updated_word })
        }.to change { chapter.reload.entries.where(word: updated_word).first.frequency }.by entry.frequency
      end
    end
  end
end