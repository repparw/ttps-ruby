module Admin
  class ProductsController < Admin::BaseController
    before_action :set_product, only: [:show, :edit, :update, :destroy]

    def index
      @products = Product.all
      authorize @products
    end

    def new
      @product = Product.new
      authorize @product
    end

    def create
      @product = Product.new(product_params)
      authorize @product

      if @product.save
        redirect_to admin_products_path, notice: 'Producto creado exitosamente.'
      else
        render :new
      end
    end

    def update
      authorize @product
      if @product.update(product_params)
        redirect_to admin_products_path, notice: 'Producto actualizado exitosamente.'
      else
        render :edit
      end
    end

    def destroy
      authorize @product
      @product.soft_delete
      redirect_to admin_products_path, notice: 'Producto eliminado exitosamente.'
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(
        :name, :description, :unit_price, :stock,
        :category_id, :size, :color, images: []
      )
    end
  end
end
