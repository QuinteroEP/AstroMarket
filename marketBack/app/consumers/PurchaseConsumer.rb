require 'cassandra'

class PurchaseConsumer < Karafka::BaseConsumer
  def consume
    messages.each do |message|
      puts "\nMensaje de compra recibido: #{message.payload}"
      product_id = Cassandra::Uuid.new(message.payload.strip)

      row = CASSANDRA_PRODUCT_SESSION.execute(
        "SELECT inventario FROM product_info WHERE id = ?",
        arguments: [product_id]
      ).first

      puts "Row from Cassandra: #{row.inspect}"
      
      if row
        current = row['inventario'].to_i
        new_val = current - 1
        puts "Current inventario: #{current}"
        puts "New value: #{new_val}"

        begin
          result = CASSANDRA_PRODUCT_SESSION.execute(
            "UPDATE productos.product_info SET inventario = ? WHERE id = ?",
            arguments: [new_val, product_id]
          )
          puts "Update result: #{result.inspect}"
        rescue => e
          puts "❌ Cassandra update failed (Purchase): #{e.class} - #{e.message}"
        end
      else
        puts "⚠️ Producto con id #{product_id} no encontrado"
      end
      
      mark_as_consumed(message)
    end
  end
end
