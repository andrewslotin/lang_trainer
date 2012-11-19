class BooksController < InheritedResources::Base
  def create
    build_resource

    resource.dictionary = Dictionary.find_by(lang: params[:book][:dictionary])

    super
  end
end
