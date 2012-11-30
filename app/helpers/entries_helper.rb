module EntriesHelper
  def link_to_translation(entry)
    link_to entry.word, "http://slovari.yandex.ru/#{entry.word}/#{entry.lang}/#lingvo"
  end
end
