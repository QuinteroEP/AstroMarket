require 'cassandra'

# connect to Cassandra cluster
CASSANDRA_CLUSTER = Cassandra.cluster(
  # hosts: ['127.0.0.1'] - desarrollo local
  # hosts: ENV.fetch("http://localhost").split(","), - docker
  hosts: ['127.0.0.1'],
  port: 9042
)

CASSANDRA_PRODUCT_SESSION = CASSANDRA_CLUSTER.connect('productos')
CASSANDRA_PRODUCT_VENDOR = CASSANDRA_CLUSTER.connect('vendedores')