class DictionariesController < InheritedResources::Base
  load_and_authorize_resource

  def create
    super do |success, failure|
      success.html { redirect_to collection_path }
      failure.html { render "new" }
    end
  end
end
