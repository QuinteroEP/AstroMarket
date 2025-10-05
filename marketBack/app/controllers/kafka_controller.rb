class KafkaController < ApplicationController
  
  def publish
    topic   = params[:topic]
    message = params[:message]

    KafkaProducerService.publish(topic, message)
  end
end