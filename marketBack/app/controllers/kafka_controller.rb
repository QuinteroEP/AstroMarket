class KafkaController < ApplicationController
  def publish
    KafkaProducerService.publish("buyer_topic", params[:message])
  end
end