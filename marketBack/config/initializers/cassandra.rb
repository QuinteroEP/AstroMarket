require 'cassandra'

hosts = if ENV['CASSANDRA_HOSTS']
  ENV.fetch("CASSANDRA_HOSTS").split(",")
else
  ['127.0.0.1']
end

CASSANDRA_CLUSTER = Cassandra.cluster(
  hosts: hosts,
  port: 9042
)

begin
  CASSANDRA_PRODUCT_SESSION = CASSANDRA_CLUSTER.connect('productos')
  Rails.logger.info "✅ Connected to Cassandra keyspace: productos"
rescue => e
  Rails.logger.error "❌ Failed to connect to productos: #{e.message}"
end

begin
  CASSANDRA_VENDOR_SESSION = CASSANDRA_CLUSTER.connect('vendedores')
  Rails.logger.info "✅ Connected to Cassandra keyspace: vendedores"
rescue => e
  Rails.logger.error "❌ Failed to connect to vendedores: #{e.message}"
end
