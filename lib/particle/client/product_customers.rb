require 'particle/product'
require 'particle/product_customer'

module Particle
  class Client
    module ProductCustomers
      def customer(product, target)
        if target.is_a? ProductCustomer
          target
        else
          ProductCustomer.new(self, product, target)
        end
      end

      # Find Customer by username
      def find_customer_by_username(product, username)
        customers = product_customers(product)
        return nil unless customers.any?

        customers.find { |c| c.username&.downcase == username&.downcase }
      end

      # Find Customer by id
      def find_customer_by_id(product, id)
        customers = product_customers(product)
        return nil unless customers.any?

        customers.find { |c| c&.id == id&.downcase }
      end

      # Find Customer by device
      def find_customer_by_device(product, device)
        customers = product_customers(product)
        return nil unless customers.any?

        customers.find { |c| c.devices.include?(device&.downcase) }
      end

      # Create a domain model for a Particle product firmware object
      #
      # @param target [String, Hash, ProductCustomer] A product id, slug, hash of attributes or {ProductCustomer} object
      # @return [ProductCustomer] A product object to interact with
      def product_customers(product)
        customers = get(ProductCustomer.collection_path(product.id))
        customers = customers[:customers] unless !customers.is_a? Hash
        customers.map do |attributes|
          customer(product, attributes)
        end
      end
    end
  end
end
