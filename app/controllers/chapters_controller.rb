# -*- encoding : utf-8 -*-

class ChaptersController < InheritedResources::Base
  belongs_to :book

  def create
    text = if params[:chapter][:content].is_a? String
             params[:chapter].delete(:content)
           else
             params[:chapter].delete(:content).tempfile.read.force_encoding("UTF-8")
           end

    params[:chapter][:title] = params[:chapter][:title].presence || text[/.+?$/].strip
    params[:chapter][:title] = "#{params[:chapter][:title].strip[/^(.{,100}.*?)\s/, 1]}…" if params[:chapter][:title].size > 100

    build_resource
    resource.entries = resource_class.build_entries(text, parent.lang == "de")

    super
  end

  def destroy
    super do |format|
      format.html { redirect_to parent }
    end
  end
end
