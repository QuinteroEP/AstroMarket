require 'cassandra'

class ItemDeleteConsumer < Karafka::BaseConsumer
  def consume
    messages.each do |message|
      puts "\nPeticion de retiro de producto: #{message.payload}"
      product_id = Cassandra::Uuid.new(message.payload.strip)

      row = CASSANDRA_PRODUCT_SESSION.execute(
        "SELECT * FROM product_info WHERE id = ?",
        arguments: [product_id]
      ).first

      puts "Row from Cassandra: #{row.inspect}"
      
      if row
        begin
          result = CASSANDRA_PRODUCT_SESSION.execute(
            "DELETE FROM product_info WHERE id = ?",
            arguments: [product_id]
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
