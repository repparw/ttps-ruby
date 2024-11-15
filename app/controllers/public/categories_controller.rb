module Public
  class CategoriesController < Public::BaseController
    def index
      @categories = Category.includes(:products).all
    end

    def show
      @category = Category.find(params[:id])
      @products = @category.products.available.page(params[:page]).per(12)
    end
  end
end
