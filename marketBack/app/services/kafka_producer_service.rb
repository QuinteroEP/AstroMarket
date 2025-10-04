class KafkaProducerService
  def self.publish(topic, payload)
    Karafka.producer.produce_async(
      topic: topic,
      payload: payload.to_json
    )
  end
end