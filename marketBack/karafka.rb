# karafka.rb
# frozen_string_literal: true

class KarafkaApp < Karafka::App
  setup do |config|
    config.client_id = "astro_market_app"
    config.kafka = {
      "bootstrap.servers": ENV.fetch("KAFKA_BROKERS", "127.0.0.1:9092")
  }
  end

  routes.draw do
    consumer_group :buyers do
      topic :buyer_topic do
        consumer PurchaseConsumer
      end
    end

    consumer_group :vendors do
      topic :vendor_inventory do
        consumer RestockConsumer
      end
      topic :vendor_sales do
        consumer SalesConsumer
      end
      topic :vendor_notfis do
        consumer NotifConsumer
      end
    end

    consumer_group :items do
      topic :item_create do
        consumer ItemCreateConsumer
      end
      topic :item_delete do
        consumer ItemDeleteConsumer
      end
      topic :item_update do
        consumer PurchaseConsumer
      end
    end
  end
end
