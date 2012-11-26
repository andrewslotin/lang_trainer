class DictionariesController < InheritedResources::Base
  load_and_authorize_resource

  def create
    super do |success, failure|
      success.html { redirect_to collection_path }
      failure.html { render "new" }
    end
  end

  def ignore
    resource.ignore_word params[:word] if params[:word].presence

    redirect_to :back
  end
end
