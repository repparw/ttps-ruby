module Admin
  class ProductsController < Admin::BaseController
    before_action :set_product, only: [ :show, :edit, :update, :destroy ]

    def index
      @products = Product.order(created_at: :desc).page(params[:page]).per(10)
      authorize @products
    end

    def show
      authorize @product
    end

    def new
      @product = Product.new
      authorize @product
    end

    def create
      @product = Product.new(product_params)
      authorize @product

      if params[:product][:images].nil? || params[:product][:images].all?(&:blank?)
        @product.errors.add(:images, "must be uploaded when creating a new product")
        render :new and return
      end

      if @product.save
        redirect_to admin_products_path, notice: "Producto creado exitosamente."
      else
        render :new
      end
    end

    def edit
      authorize @product
    end

    def update
      authorize @product

      # Include images if new files were actually selected
      has_new_images = params[:product][:images]&.any? { |image| !image.blank? }

      if has_new_images
        update_successful = @product.update(product_params)
      else
        update_successful = @product.update(product_params.except(:images))
      end

      if update_successful
        redirect_to admin_products_path, notice: "Producto actualizado exitosamente."
      else
        render :edit
      end
    end

    def destroy
      authorize @product
      @product.soft_delete
      redirect_to admin_products_path, notice: "Producto eliminado exitosamente."
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(
        :name, :description, :price, :stock,
        :category_id, :size, :color, :entry_at, images: []
      )
    end
  end
end
