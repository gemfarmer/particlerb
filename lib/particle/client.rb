require 'particle/connection'
require 'particle/client/devices'
require 'particle/client/products'
require 'particle/client/publish'
require 'particle/client/webhooks'
require 'particle/client/tokens'
require 'particle/client/firmware'
require 'particle/client/build_targets'
require 'particle/client/platforms'
require 'particle/client/oauth_clients'
require 'particle/client/product_firmwares'
require 'particle/client/product_customers'

module Particle

  # Client for the Particle API
  #
  # @see http://docs.particle.io/
  class Client
    include Particle::Configurable
    include Particle::Connection
    include Particle::Client::Devices
    include Particle::Client::Products
    include Particle::Client::Publish
    include Particle::Client::Webhooks
    include Particle::Client::Tokens
    include Particle::Client::Firmware
    include Particle::Client::BuildTargets
    include Particle::Client::Platforms
    include Particle::Client::OAuthClients
    include Particle::Client::ProductFirmwares
    include Particle::Client::ProductCustomers

    def initialize(options = {})
      # Use options passed in, but fall back to module defaults
      Particle::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || Particle.instance_variable_get(:"@#{key}"))
      end
    end

    # Text representation of the client, masking tokens
    #
    # @return [String]
    def inspect
      inspected = super

      # Only show last 4 of token, secret
      if @access_token
        inspected = inspected.gsub! @access_token, "#{'*'*36}#{@access_token[36..-1]}"
      end

      inspected
    end

    # Set OAuth2 access token for authentication
    #
    # @param value [String] 40 character Particle OAuth2 access token
    def access_token=(value)
      reset_connection
      @access_token =
        if value.respond_to? :access_token
          value.access_token
        else
          value
        end
    end

    # Set OAuth2 access token for authentication
    #
    # @param value [String] 40 character Particle OAuth2 access token
    def client_id=(value)
      reset_connection
      @client_id =
        if value.respond_to? :client_id
          value.client_id
        else
          value
        end
    end

    def client_secret=(value)
      reset_connection
      @client_secret =
        if value.respond_to? :client_secret
          value.client_secret
        else
          value
        end
    end
  end
end
