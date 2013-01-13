class EntriesController < InheritedResources::Base
  belongs_to :book, optional: true do
    belongs_to :dictionary, :chapter, polymorphic: true
  end

  has_scope :page, default: 1

  def create
    if parent.is_a? Dictionary
      parent << build_resource
      parent.save
    end

    respond_with_dual_blocks(parent, {}) do |success, failure|
      success.html { redirect_to action: :index }
      failure.html { render "new" }
    end
  end

  def update
    existing_entry = if params[:entry][:word] != resource.word
                       parent.entries.where(word: params[:entry][:word]).first
                     end

    if existing_entry
      existing_entry.inc(:frequency, resource.frequency)
      resource.destroy
    else
      resource.update_attributes params[:entry]
      resource.save
    end

    respond_with_dual_blocks(resource, {}) do |success, failure|
      success.html { redirect_to action: :index }
      failure.html { render "edit" }
    end
  end

  def complete
    resource.dictionary << resource
    resource.dictionary.save && resource.destroy

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

  def learning_list
    @entries = collection.marked

    render :index
  end

  def mark
    resource.mark!

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: { result: "ok" } }
    end
  end

  def unmark
    resource.unmark!

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: { result: "ok" } }
    end
  end

  def destroy
    super do |format|
      format.html { redirect_to action: :index }
    end
  end
end
