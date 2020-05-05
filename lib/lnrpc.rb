require 'lnrpc/version'
require 'lnrpc/rpc_services_pb'
require 'lnrpc/router_services_pb'
require 'securerandom'

module Lnrpc
  class Error < StandardError; end
  autoload :Client, 'lnrpc/client'
  autoload :GrpcWrapper, 'lnrpc/grpc_wrapper'
  autoload :MacaroonInterceptor, 'lnrpc/macaroon_interceptor'

  PREIMAGE_BYTE_LENGTH = 32
  KEY_SEND_PREIMAGE_TYPE = 5482373484

  def self.create_preimage
    SecureRandom.random_bytes(PREIMAGE_BYTE_LENGTH)
  end

  def self.to_byte_array(str)
    [str].pack("H*")
  end
end
