module Public
  class ProductsController < Public::BaseController
    def index
      @products = Product.available.limit(20).order(created_at: :desc)
      @categories = Category.all
    end

    def show
     @product = Product.find(params[:id])
    end
  end
end

