class EntriesController < InheritedResources::Base
  belongs_to :book, optional: true do
    belongs_to :dictionary, :chapter, polymorphic: true
  end

  def create
    resource = parent.entries.create params[:entry]

    super do |success, failure|
      success.html { redirect_to :back }
      failure.html { render "new" }
    end
  end

  def show
    resource.translate! parent.lang

    super
  end

  def ignore
    resource.ignore!

    redirect_to :back
  end

  def destroy
    super do |format|
      format.html { redirect_to parent }
    end
  end
end
