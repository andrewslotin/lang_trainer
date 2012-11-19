class BooksController < InheritedResources::Base
  belongs_to :dictionary, optional: true

  def create
    build_resource

    resource.dictionary = Dictionary.find_by(lang: params[:book][:dictionary])

    super
  end
end
