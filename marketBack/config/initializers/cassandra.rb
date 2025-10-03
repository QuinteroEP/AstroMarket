require 'cassandra'

# connect to Cassandra cluster
CASSANDRA_CLUSTER = Cassandra.cluster(
  hosts: ENV.fetch("CASSANDRA_HOSTS").split(","),
  port: 9042
)

CASSANDRA_PRODUCT_SESSION = CASSANDRA_CLUSTER.connect('productos')
CASSANDRA_PRODUCT_VENDOR = CASSANDRA_CLUSTER.connect('vendedores')