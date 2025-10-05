require 'cassandra'

class RestockConsumer < Karafka::BaseConsumer
  def consume
    messages.each do |message|
      puts "\nPeticion de restock para producto: #{message.payload}"
      product_id = Cassandra::Uuid.new(message.payload.strip)

      row = CASSANDRA_PRODUCT_SESSION.execute(
        "SELECT * FROM product_info WHERE id = ?",
        arguments: [product_id]
      ).first

      puts "Row from Cassandra: #{row.inspect}"
      
      if row
        current = row['inventario'].to_i
        max = row['inventario_max'].to_i
        new_val = max
        puts "Current inventario: #{current}"
        puts "New inventario: #{new_val}"

        begin
          result = CASSANDRA_PRODUCT_SESSION.execute(
            "UPDATE productos.product_info SET inventario = ? WHERE id = ?",
            arguments: [new_val, product_id]
          )
          puts "Update result: #{result.inspect}"
        rescue => e
          puts "❌ Cassandra update failed: #{e.class} - #{e.message}"
        end
      else
        puts "⚠️ Producto con id #{product_id} no encontrado"
      end
      
      mark_as_consumed(message)
    end
  end
end
