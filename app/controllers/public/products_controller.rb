module Public
  class ProductsController < Public::BaseController
    def index
      @q = Product.ransack(params[:q])
      @products = @q.result(distinct: true).available.order(created_at: :asc).page(params[:page]).per(20)
      @categories = Category.all
    end

    def show
     @product = Product.find(params[:id])
    end
  end
end
