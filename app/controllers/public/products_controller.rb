module Public
  class ProductsController < Public::BaseController
    def index
      @products = Product.available.limit(20).order(created_at: :desc)
      @categories = Category.all
    end
  end
end
