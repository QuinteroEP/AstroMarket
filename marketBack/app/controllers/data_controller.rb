class DataController < ApplicationController
  def productIndex
    results = CASSANDRA_PRODUCT_SESSION.execute("SELECT nombre, precio, inventario FROM product_info;")
    render json: results.map(&:to_h)
  end
end
