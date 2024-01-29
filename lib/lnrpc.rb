require 'lnrpc/version'

# require GRPC services
Dir[File.join(File.expand_path(File.dirname(__FILE__)), 'grpc_services/**/*_services_pb.rb')].each do |file|
  require file
end

require 'securerandom'

module Lnrpc
  class Error < StandardError; end
  autoload :Client, 'lnrpc/client'
  autoload :GrpcWrapper, 'lnrpc/grpc_wrapper'
  autoload :PaymentResponse, 'lnrpc/payment_response'
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
