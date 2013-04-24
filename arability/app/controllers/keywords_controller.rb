class KeywordsController < BackendController

  # Author:
  #   Mohamed Ashraf
  # Description:
  #   Displays the form
  # params:
  #   name: the name of the new keyword
  #   category_ids: the ids of the categories it should be tagged with
  # success:
  #   shows the form with the apropriate fields filled
  # failure:
  #   --
  def new
    @keyword = Keyword.new(name: params[:name])
    @categories_by_locale = Category.all.map { |c| [c.id, c.get_name_by_locale] }
    @category_ids = params[:category_ids] || ""
    @category_ids = @category_ids.split(",")
  end

  # Author:
  #   Mohamed Ashraf
  # Description:
  #   Creates a new keyword and tags it with selected categories
  # params:
  #   name: the name of the new keyword
  #   redirect: the url to redirect to after the creation defaults to new
  #             keyword path
  #   is_english: the language of the keyword
  #   category_ids: the ids of the categories it should be tagged with
  #   override_categories: if present then the categories replace the originals rather than
  #            appending to them
  # success:
  #   goes to the keyword profile
  # failure:
  #   refreshes the page with error displayed
  def create
    redirect_url = params[:redirect]
    category_ids = params[:category_ids]
    override = params[:override_categories].present?

    categories = Category.where(id: category_ids)

    if redirect_url.blank?
      redirect_url = search_path
    end

    name = params[:keyword][:name]
    is_english = params[:keyword][:is_english]

    @keyword = Keyword.find_by_name(name)

    if @keyword
      if categories.present?
        if override
          @keyword.categories = categories
        else
          @keyword.categories << categories
        end
        categories.map! { |c| c.get_name_by_locale }
        category_string = categories.join(", ")
        flash[:success] = t(:keyword_added_to_categories,
          keyword: @keyword.name, categories: category_string)
      else
        flash[:error] = t(:keyword_exists)
      end
        redirect_to search_path(search: @keyword.name), flash: flash
    else
      success, @keyword = Keyword.add_keyword_to_database(name, false, is_english, categories)
      if success
        flash[:success] = t(:keyword_added, keyword: @keyword.name)
        redirect_to search_path(search: @keyword.name), flash: flash
      else
        flash[:error] = @keyword.errors.messages[:name]
        redirect_to keywords_new_path, flash: flash
      end
    end
  end
end
