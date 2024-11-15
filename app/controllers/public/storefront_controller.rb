module Public
  class StorefrontController < Public::BaseController
    def index
      @products = Product.available.page(params[:page]).per(20)
      @categories = Category.all
    end
  end
end
