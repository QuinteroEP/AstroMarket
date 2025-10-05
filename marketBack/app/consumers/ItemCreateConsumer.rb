require 'cassandra'

class ItemCreateConsumer < Karafka::BaseConsumer
  def consume
    messages.each do |message|
      puts "\nNueva peticion de modificacion: #{message.payload}"
      data = JSON.parse(message.payload) rescue {}

      nombre = data['nombre']
      precio = data['precio'].to_f
      inventario = data['InvMax'].to_i

      if data['id'].nil? || data['id'].strip.empty?
        product_id = Cassandra::Uuid::Generator.new.uuid
      else
        product_id = Cassandra::Uuid.new(data['id'])
      end

      puts "Valores: #{nombre}, #{precio}, #{inventario}"
      
      row = CASSANDRA_PRODUCT_SESSION.execute(
        "SELECT * FROM product_info WHERE id = ?",
        arguments: [product_id]
      ).first

      if row
        puts "Actualizcaion de producto"
        begin
            result = CASSANDRA_PRODUCT_SESSION.execute(
              "UPDATE productos.product_info SET inventario = ?, inventario_max = ?, nombre = ?, precio = ?  WHERE id = ?",
              arguments: [inventario, inventario, nombre, precio, product_id]
            )
            puts "Update result: #{result.inspect}"
        rescue => e
            puts "❌ Cassandra update failed (Sale Update): #{e.class} - #{e.message}"
        end
      
      else
        puts "Nuevo producto"
        puts "ID: #{product_id}"
        begin
          result = CASSANDRA_PRODUCT_SESSION.execute(
            "INSERT INTO product_info (id, precio, inventario, inventario_max, nombre) VALUES (?, ?, ?, ?, ?)",
            arguments: [product_id, precio, inventario, inventario, nombre]
          )
          puts "insert result: #{result.inspect}"
        rescue => e
          puts "❌ Cassandra insert failed (Notif): #{e.class} - #{e.message}"
        end
      end
      mark_as_consumed(message)
    end
  end
end
