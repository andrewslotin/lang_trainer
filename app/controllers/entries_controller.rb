class EntriesController < InheritedResources::Base
  belongs_to :book, optional: true do
    belongs_to :dictionary, :chapter, polymorphic: true
  end

  def create
    super do |success, failure|
      success.html { redirect_to :back }
      failure.html { render "new" }
    end
  end

  def update
    existing_entry = parent.entries.where(word: params[:entry][:word]).first

    if existing_entry
      existing_entry.inc(:frequency, resource.frequency)
      resource.destroy
    else
      resource.update_attribute :word, params[:entry][:word]
    end

    respond_with_dual_blocks(resource, {}) do |success, failure|
      success.html { redirect_to action: :index }
      failure.html { render "edit" }
    end
  end

  def complete
    resource.dictionary << resource
    resource.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: { result: "ok" } }
    end
  end

  def ignore
    resource.dictionary.ignore_word resource.word

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: { result: "ok" } }
    end
  end

  def destroy
    super do |format|
      format.html { redirect_to parent }
    end
  end
end
