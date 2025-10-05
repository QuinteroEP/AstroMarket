require 'cassandra'

class SalesConsumer < Karafka::BaseConsumer
  def consume
    messages.each do |message|
      puts "\nNueva venta: #{message.payload}"
      product_id = Cassandra::Uuid.new(message.payload.strip)

      row = CASSANDRA_PRODUCT_SESSION.execute(
        "SELECT * FROM product_info WHERE id = ?",
        arguments: [product_id]
      ).first
      
      puts "Row from Cassandra: #{row.inspect}"

      if row
        name = row["nombre"]
        precio = row["precio"].to_i

        sale = CASSANDRA_VENDOR_SESSION.execute(
          "SELECT * FROM ventas WHERE id = ?",
          arguments: [product_id]
        ).first

        if sale
          current = sale['unidades_vendidad'].to_i
          new_val = current + 1
          puts "Current ventas: #{current}"
          puts "New value: #{new_val}"

          begin
            puts "\nRegistro existente"
            result = CASSANDRA_VENDOR_SESSION.execute(
              "UPDATE vendedores.ventas SET unidades_vendidad = ? WHERE id = ?",
              arguments: [new_val, product_id]
            )
            puts "Update result: #{result.inspect}"
          rescue => e
            puts "❌ Cassandra update failed (Sale Update): #{e.class} - #{e.message}"
          end

        else
          begin
            puts "\nNuevo registro"
            result = CASSANDRA_VENDOR_SESSION.execute(
              "INSERT INTO vendedores.ventas (id, precio_unitario, producto, unidades_vendidad) VALUES (?, ?, ?, 1)",
              arguments: [product_id, precio, name]
            )
            puts "Update result: #{result.inspect}"
          rescue => e
            puts "❌ Cassandra update failed (Sale Insert): #{e.class} - #{e.message}"
          end
        end
      else
        puts "⚠️ Producto con id #{product_id} no encontrado"
      end

      mark_as_consumed(message)
    end
  end
end
