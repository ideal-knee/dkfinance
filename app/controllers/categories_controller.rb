class CategoriesController < ApplicationController
  before_filter :authenticate_user!

  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # GET /categories
  # GET /categories.json
  def index
    @categories = current_user.categories.order(:name)
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    render status: :forbidden, text: "Forbidden!" unless @category.user == current_user
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
    render status: :forbidden, text: "Forbidden!" unless @category.user == current_user
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params.merge(user: current_user))

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Category was successfully created.' }
        format.json { render action: 'show', status: :created, location: @category }
      else
        format.html { render action: 'new' }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    render status: :forbidden, text: "Forbidden!" unless @category.user == current_user

    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to categories_url, notice: 'Category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    render status: :forbidden, text: "Forbidden!" unless @category.user == current_user

    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :budget, :parent_category_id)
    end
end
