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
        if customers.any?
          customers.find { |c| c.username == username }
        else
          nil
        end
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
