# AstroMarket
Web Marketplace built with Astro JS, Ruby on Rails and Kafka

# CARGAR BASE DE DATOS AL CONTAINER DE CASSANDRA
## Schemas y tablas 
1. productos.cql: product_info.csv
2. vendedores.cql: notificaciones.cvs, ventas.csv

## Pasos
2. Cargar los Schemas de la base de datos desde Docker con 'docker exec -i cassandra-db cqlsh < [nombreShcema].cql'
3. (Opcional) Cargar la data de cada tabla desde Docker con 'docker cp [nombreTabla].csv cassandra-db:/tmp/' y 'docker exec -it cassandra-db cqlsh -e "COPY [nombreShcema].[nombreTabla] FROM '/tmp/[nombreTabla].csv' WITH HEADER = true;"'

Ejemplo: 'docker exec -i cassandra-db cqlsh < productos.cql', 'docker exec -it cassandra-db cqlsh -e "COPY productos.product_info FROM '/tmp/product_info.csv' WITH HEADER = true;"'

# INSTALACION POR DOCKER
1. Instalar la imagen de Cassandra 4.1 con el nombre 'cassandra-db'
2. Construir y ejecutar el Container del sistema con 'docker-compose up --build'
3. Ejecutar 'docker exec -it astromarket-rails-karafka-1 bash' y 'bundle exec karafka topics' para activar Karafka
4. Navegar al root del projecto y ejectuar Astro con 'npm run dev'
5. Acceder a la pagina por 'http://localhost:4321'