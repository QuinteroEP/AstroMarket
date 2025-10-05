# AstroMarket
Web Marketplace built with Astro JS, Ruby on Rails and Kafka

# CARGAR BASE DE DATOS AL CONTAINER DE CASSANDRA
## Schemas y tablas 
1. productos.cql: product_info.csv
2. vendedores.cql: notificaciones.cvs, ventas.csv

## Pasos
1. Instalar la imagen de Cassandra 4.1 con el nombre 'cassandra-db'
2. Cargar los Schemas de la base de datos con 'docker exec -i cassandra-db cqlsh < [nombreShcema].cql'
3. Cargar la data de cada tabla con 'docker cp [nombreTabla].csv cassandra-db:/tmp/' y 'docker exec -it cassandra-db cqlsh -e "COPY [nombreShcema].[nombreTabla] FROM '/tmp/[nombreTabla].csv' WITH HEADER = true;"'

Ejemplo: 'docker exec -i cassandra-db cqlsh < productos.cql', 'docker exec -it cassandra-db cqlsh -e "COPY productos.product_info FROM '/tmp/product_info.csv' WITH HEADER = true;"'

# INSTALACION POR DOCKER
1. Realizar la instalacion de la imagen de Cassandra
2. Instalar la imagen de Kafka con el nombre 'upbeat_wu'
3. Instalar de forma local Astro
4. Construir y ejecutar el Container del sistema con 'docker-compose up --build'
5. Acceder a la pagina por 'http://localhost:4321'