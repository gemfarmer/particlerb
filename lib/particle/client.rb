require 'particle/connection'
require 'particle/client/devices'
require 'particle/client/publish'
require 'particle/client/webhooks'
require 'particle/client/tokens'

module Particle

  # Client for the Particle API
  #
  # @see http://docs.particle.io/
  class Client
    include Particle::Configurable
    include Particle::Connection
    include Particle::Client::Devices
    include Particle::Client::Publish
    include Particle::Client::Webhooks
    include Particle::Client::Tokens

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
      reset_agent
      @access_token = value
    end
  end
end
