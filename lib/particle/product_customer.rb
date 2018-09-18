require 'particle/model'
require 'particle/product'

module Particle
  # Domain model for one Particle device
  class ProductCustomer < Model
    ID_REGEX = /^\d{1,6}$/

    def initialize(client, product_or_id, attributes)
      super(client, attributes)

      product = client.product(product_or_id)

      @attributes = { version: attributes } if attributes.is_a?(Integer) || attributes.is_a?(String)
      @attributes = @attributes.merge(product: product, product_id: product.id)

      @fully_loaded = true if @attributes.key?(:username)
    end

    def get_attributes
      @loaded = @fully_loaded = true
      @attributes = @client.product_firmware_attributes(self)
    end

    def id
      get_attributes unless @attributes[:id]
      @attributes[:id]
    end

    def username
      get_attributes unless @attributes[:username]
      @attributes[:username]
    end

    def devices
      get_attributes unless @attributes[:devices]
      @attributes[:devices]
    end

    def product
      @attributes[:product]
    end

    def product_id
      product.id
    end

    def path
      "/v1/products/#{product_id}/customers"
    end

    def self.collection_path(product_id_)
      "/v1/products/#{product_id_}/customers"
    end
  end
end
