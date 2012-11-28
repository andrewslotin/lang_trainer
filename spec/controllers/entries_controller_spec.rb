# -*- encoding : utf-8 -*-
require "spec_helper"

describe EntriesController do
  let(:user) { FactoryGirl.create :twitter_user }
  let!(:dictionary) { FactoryGirl.create :dictionary, user: user }
  let(:chapter) { FactoryGirl.build :chapter }
  let(:entry) { FactoryGirl.build :entry }
  let(:book) do
    book = FactoryGirl.create :book, dictionary: dictionary
    chapter.entries << entry
    book.chapters << chapter

    book.save!
    book
  end

  before do
    book.stub(:dictionary).and_return dictionary
    Book.stub(:find).and_return book
    book.stub_chain(:chapters, :find).with(chapter._id.to_s).and_return chapter
    chapter.stub_chain(:entries, :find).with(entry._id.to_s).and_return entry

    subject.stub(:current_user).and_return user
  end

  describe "ignore" do
    let(:referrer_address) { book_chapter_path(book, chapter) }

    before do
      request.env["HTTP_REFERER"] = referrer_address
      dictionary.stub! :ignore_word
    end

    it "should redirect back" do
      post :ignore, book_id: book._id, chapter_id: chapter._id, id: entry._id

      expect(response).to redirect_to referrer_address
    end

    it "should call Dictionary#ignore_word with given Entry#word" do
      dictionary.should_receive(:ignore_word).with entry.word

      post :ignore, book_id: book._id, chapter_id: chapter._id, id: entry._id
    end
    
  end
end