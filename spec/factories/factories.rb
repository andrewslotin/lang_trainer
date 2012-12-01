require 'factory_girl'

FactoryGirl.define do
  sequence(:uid) { |n| n }
  sequence(:dictionary_name) { |n| "Dictionary #{n}" }
  sequence(:book_title) { |n| "Book #{n}" }
  sequence(:word_seq) { |n| "word#{n}" }

  factory :user do
    name { Faker::Name.name }
    identities []

    factory :twitter_user do
      identities { [FactoryGirl.build(:twitter_identity)] }
    end
  end

  factory :identity do
    provider :developer

    factory :twitter_identity do
      provider :twitter
    end
  end

  factory :dictionary do
    title { generate(:dictionary_name) }
    lang :en
    ignored_words []

    association :user

    factory :dictionary_with_books do
      ignore do
        books_count 3
      end

      #books { (0...3).map { |i| FactoryGirl.build(:book) } }
      after(:create) do |dict, evaluator|
        FactoryGirl.create_list(:book, evaluator.books_count, dictionary: dict)
      end
    end
  end

  factory :book do
    dictionary

    title { generate(:book_title) }

    factory :book_with_chapters do
      ignore do
        chapters_count 5
      end
    
      chapters { (0...3).map { |i| FactoryGirl.build(:chapter) } }
    end
  end

  factory :chapter do
    factory :chapter_with_entries do
      ignore do
        entries_count 10
      end

      after(:build) do |chapter, evaluator|
        chapter[:entries] = (0...evaluator.entries_count).map { FactoryGirl.build(:entry) }
        chapter.words_number = chapter.entries.sum { |entry| entry.frequency }
      end
    end
  end

  factory :entry do
    word { generate(:word_seq) }
    frequency { rand(1000) }

    factory :entry_with_variants do
      ignore do
        variants_count 5
      end

      variants { (0..5).map { generate(:word_seq) } }
    end
  end
end