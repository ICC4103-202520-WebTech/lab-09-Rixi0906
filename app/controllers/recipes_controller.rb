class RecipesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :authorize_owner!, only: [:edit, :update, :destroy]

  def index
    @recipes = Recipe.includes(:user).order(created_at: :desc)
  end

  def show; end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = current_user.recipes.build(recipe_params) 
    if @recipe.save
      redirect_to @recipe, notice: "Recipe Created Successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: "Recipe Updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe.destroy
    redirect_to recipes_path, notice: "Recipe Deleted."
  end

  private
  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def authorize_owner!
    redirect_to @recipe, alert: "Please log in first." unless @recipe.user == current_user
  end

  def recipe_params
    params.require(:recipe).permit(:title, :cook_time, :difficulty, :instructions)
  end
end
