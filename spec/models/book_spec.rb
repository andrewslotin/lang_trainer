# -*- encoding : utf-8 -*-
require "spec_helper"

describe Book do
  subject { FactoryGirl.create :book }
  let(:word) { "the" }

  describe "ignore_word" do
    context "for each chapter in book" do
      let(:chapters) do
        (0...3).map { |i| FactoryGirl.build :chapter }
      end

      before do
        subject.chapters = chapters
        subject.save!
      end

      it "calls Chapter#ignore_word with given word" do
        chapters.each do |chapter|
          chapter.should_receive :ignore_word, with: word
        end

        subject.ignore_word word
      end
    end
  end
end