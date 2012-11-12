class EntriesController < InheritedResources::Base
  belongs_to :dictionary

  def create
    super do |success, failure|
      success.html { redirect_to parent }
      failure.html { render "new" }
    end
  end

  def destroy
    super do |format|
      format.html { redirect_to parent }
    end
  end
end
