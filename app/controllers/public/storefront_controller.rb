module Public
  class StorefrontController < Public::BaseController
    def index
      @products = Product.available.limit(20)
      @categories = Category.all
    end
  end
end
