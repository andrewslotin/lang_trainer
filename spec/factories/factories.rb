require 'factory_girl'

FactoryGirl.define do
  sequence(:uid) { |n| n }
  sequence(:dictionary_name) { |n| "Dictionary #{n}" }
  sequence(:book_title) { |n| "Book #{n}" }
  sequence(:word_seq) { |n| "word#{n}" }

  factory :user do
    uid { generate :uid }
    name { Faker::Name.name }

    trait :twitter do
      provider :twitter
    end
  end

  factory :dictionary do
    title { generate(:dictionary_name) }
    lang :en
    ignored_words []

    association :user, :twitter

    factory :dictionary_with_books do
      ignore do
        books_count 3
      end

      after(:create) do |dict, evaluator|
        FactoryGirl.create_list(:book, evaluator.books_count, dictionary: dict)
      end
    end
  end

  factory :book do
    title { generate(:book_title) }
    dictionary

    factory :book_with_chapters do
      ignore do
        chapters_count 5
      end

      after(:create) do |book, evaluator|
        FactoryGirl.create_list(:chapter, evaluator.chapters_count, book: book)
      end
    end
  end

  factory :chapter do
    book

    factory :chapter_with_entries do |chapter, evaluator|
      ignore do
        entries_count 10
      end

      FactoryGirl.create_list(:chapter_entry, evaluator.entries_count, source: chapter)
      chapter.update_attribute :words_number, chapter.entries.sum { |entry| entry.frequency }
    end
  end

  factory :entry do
    word { generate(:word_seq) }
    frequency rand(1000)

    trait :chapter do
      association :source, factory: :chapter
    end

    trait :dictionary do
      association :source, factory: :dictionary
    end
  end
end