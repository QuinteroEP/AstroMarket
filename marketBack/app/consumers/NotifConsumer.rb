require 'cassandra'
require 'date'

class NotifConsumer < Karafka::BaseConsumer
  def consume
    messages.each do |message|
      puts "\nNueva notificacion: #{message.payload}"
      product_id = Cassandra::Uuid.new(message.payload.strip)

      row = CASSANDRA_PRODUCT_SESSION.execute(
        "SELECT * FROM product_info WHERE id = ?",
        arguments: [product_id]
      ).first
      
      puts "Row from Cassandra: #{row.inspect}"

      if row
        name = row["nombre"]
        id = Cassandra::Uuid::Generator.new.uuid
        fecha = Time.now 
        type = "Venta"

        puts "Current date: #{fecha}"

        begin
          result = CASSANDRA_VENDOR_SESSION.execute(
            "INSERT INTO vendedores.notificaciones (id, fecha, producto, tipo) VALUES (?, ?, ?, ?)",
            arguments: [id, fecha, name, type]
          )
          puts "Update result: #{result.inspect}"
        rescue => e
          puts "❌ Cassandra update failed (Notif): #{e.class} - #{e.message}"
        end
      else
        puts "⚠️ Producto con id #{product_id} no encontrado"
      end

      mark_as_consumed(message)
    end
  end
end
