require 'cassandra'

# connect to Cassandra cluster
CASSANDRA_CLUSTER = Cassandra.cluster(
  hosts: ['127.0.0.1'], # use 'cassandra' if Rails runs inside Docker with Cassandra
  port: 9042
)

# connect to your keyspace (replace 'data' if different)
CASSANDRA_PRODUCT_SESSION = CASSANDRA_CLUSTER.connect('productos')
