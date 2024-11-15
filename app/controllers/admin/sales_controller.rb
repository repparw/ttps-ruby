module Admin
  class SalesController < Admin::BaseController
    before_action :set_sale, only: [ :show, :cancel ]

    def index
      @sales = Sale.includes(:products, :user).active.order(created_at: :desc).page(params[:page]).per(5)
      authorize @sales
    end

    def show
      authorize @sale
    end

    def new
      @sale = Sale.new
      @sale.sale_items.build if @sale.sale_items.empty?
      authorize @sale
    end

    def create
      @sale = Sale.new(sale_params)
      @sale.user = current_user
      authorize @sale

      if @sale.save
        redirect_to admin_sales_path, notice: "Venta registrada exitosamente."
      else
        render :new
      end
    end

    def cancel
      authorize @sale
      if @sale.cancel
        redirect_to admin_sales_path, notice: "Venta cancelada exitosamente."
      else
        redirect_to admin_sales_path, alert: "No se pudo cancelar la venta."
      end
    end

    private

    def set_sale
      @sale = Sale.find(params[:id])
    end

    def sale_params
      params.require(:sale).permit(
        :user_id,
        :customer_id,
        :sale_date,
        sale_items_attributes: [ :product_id, :quantity, :price ]
      )
    end
  end
end
