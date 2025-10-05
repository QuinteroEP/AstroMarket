class DataController < ApplicationController
  def productIndex
    results = CASSANDRA_PRODUCT_SESSION.execute("SELECT * FROM product_info;")
    render json: results.map {|row| 
        {
          id: row['id'].to_s, 
          nombre: row['nombre'],
          precio: row['precio'],
          inventario: row['inventario'],
          inventario_max: row['inventario_max']
        }
      }
  end

  def salesIndex
    results = CASSANDRA_VENDOR_SESSION.execute("SELECT * FROM ventas")
    render json: results.map {|row| 
        {
          id: row['id'].to_s, 
          precio_unitario: row['precio_unitario'],
          producto: row['producto'],
          unidades_vendidad: row['unidades_vendidad']
        }
      }
  end

  def notifIndex
    results = CASSANDRA_VENDOR_SESSION.execute("SELECT * FROM notificaciones")
    render json: results.map {|row| 
        {
          id: row['id'].to_s, 
          producto: row['producto'],
          fecha: row['fecha'],
          tipo: row['tipo']
        }
      }
  end
end
