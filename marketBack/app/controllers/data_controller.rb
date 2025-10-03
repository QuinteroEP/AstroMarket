class DataController < ApplicationController
  def productIndex
    results = CASSANDRA_PRODUCT_SESSION.execute("SELECT * FROM product_info;")
    render json: results.map {|row| 
        {
          id: row['id'].to_s, 
          nombre: row['nombre'],
          precio: row['precio'],
          inventario: row['inventario']
        }
      }
  end

  def salesIndex
    results = CASSANDRA_PRODUCT_VENDOR.execute("SELECT * FROM ventas")
    render json: results.map(&:to_h)
  end

  def notifIndex
    results = CASSANDRA_PRODUCT_VENDOR.execute("SELECT * FROM notificaciones")
    render json: results.map(&:to_h)
  end
end
