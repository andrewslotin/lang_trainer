# -*- encoding : utf-8 -*-

class ChaptersController < InheritedResources::Base
  belongs_to :book

  def create
    text = if params[:chapter][:content].is_a? String
             params[:chapter].delete(:content)
           else
             params[:chapter].delete(:content).tempfile.read.force_encoding("UTF-8")
           end

    params[:chapter][:title] = if params[:chapter][:title].presence
                                 params[:chapter]
                               end
    unless params[:chapter][:title].present?
      title = (text[/.+?$/] || "").strip
      "#{title.strip[/^(.{,50}.*?)\s/, 1]}…" if title.size > 50

      params[:chapter][:title] = title.presence || "#{resource_class.name} #{parent.chapters.size + 1}"
    end

    build_resource
    resource.build_entries_from(text, parent.lang == "de")

    super do |success, failure|
      success.html { redirect_to book_chapter_entries_path(parent, resource) }
      failure.html { render "new" }
    end
  end

  def destroy
    super do |format|
      format.html { redirect_to parent }
    end
  end
end
