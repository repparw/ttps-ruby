class Admin::DashboardController < Admin::BaseController
  def index
    @recent_sales = Sale.order(created_at: :desc).limit(10)
    @best_selling_products = Product.available.joins(:sale_items)
                                   .group(:id)
                                   .order("sum(sale_items.quantity) DESC")
                                   .limit(5)
    @low_stock_products = Product.available.where("stock < 10")
    @total_sales = Sale.sum(:total)
  end
end

