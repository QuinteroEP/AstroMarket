class KarafkaApp < Karafka::App
  setup do |config|
    config.kafka = { 'bootstrap.servers': '127.0.0.1:9092' }
    config.client_id = "YOUR_APP_NAME-#{Process.pid}-#{Socket.gethostname}"
    config.group_id = 'YOUR_APP_NAME_consumer'
    config.consumer_persistence = !Rails.env.development?
  end

  routes.draw do
    topic :example do
      consumer ExampleConsumer
    end
  end
end
