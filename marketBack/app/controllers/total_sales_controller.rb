require 'cassandra'

class TotalSalesController < ApplicationController
  def index
    puts "\nActualizando ventas totales"

    gananciasTotales = 0

    row = CASSANDRA_VENDOR_SESSION.execute("SELECT unidades_vendidad, precio_unitario FROM ventas;")
    row.each do |row|
      unidades = row['unidades_vendidad']
      precio   = row['precio_unitario']

      puts "\nUnidades y precios: #{unidades}, #{precio}" 
      gananciasTotales = gananciasTotales + unidades*precio
    end

    puts "Ganancias totales: #{gananciasTotales}"

    render json: { ganancias_totales: gananciasTotales }
  end
end
