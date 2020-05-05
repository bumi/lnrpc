require "grpc"
require "lnrpc/macaroon_interceptor"
module Lnrpc
  class Client
    attr_accessor :address, :credentials, :macaroon

    LND_HOME_DIR = ENV['LND_HOME'] || "~/.lnd"
    DEFAULT_ADDRESS = 'localhost:10009'
    DEFAULT_CREDENTIALS_PATH = "#{LND_HOME_DIR}/tls.cert"
    DEFAULT_MACAROON_PATH = "#{LND_HOME_DIR}/data/chain/bitcoin/mainnet/admin.macaroon"

    def initialize(options={})
      self.address = options[:address] || DEFAULT_ADDRESS

      if options.has_key?(:credentials)
        self.credentials = options[:credentials]
      elsif File.exists?(::File.expand_path(options[:credentials_path] || DEFAULT_CREDENTIALS_PATH))
        self.credentials = ::File.read(::File.expand_path(options[:credentials_path] || DEFAULT_CREDENTIALS_PATH))
      else
        self.credentials = nil
      end

      if !options.has_key?(:macaroon) && File.exists?(::File.expand_path(options[:macaroon_path] || DEFAULT_MACAROON_PATH))
        options[:macaroon] = ::File.read(::File.expand_path(options[:macaroon_path] || DEFAULT_MACAROON_PATH)).unpack("H*")
      end
      self.macaroon = options[:macaroon]
    end

    def lightning
      @lightning ||= GrpcWrapper.new(Lnrpc::Lightning::Stub.new(address,
                                                    GRPC::Core::ChannelCredentials.new(credentials),
                                                    interceptors: [Lnrpc::MacaroonInterceptor.new(macaroon)]
                                                  ))
    end

    def router
      @router ||= GrpcWrapper.new(Routerrpc::Router::Stub.new(address,
                                                    GRPC::Core::ChannelCredentials.new(credentials),
                                                    interceptors: [Lnrpc::MacaroonInterceptor.new(macaroon)]
                                                  ))
    end

    def keysend(args)
      args[:dest_custom_records] ||= {}
      args[:dest_custom_records][Lnrpc::KEY_SEND_PREIMAGE_TYPE] ||= Lnrpc.create_preimage
      args[:payment_hash] ||= Digest::SHA256.digest(args[:dest_custom_records][Lnrpc::KEY_SEND_PREIMAGE_TYPE])
      args[:timeout_seconds] ||= 60
      router.send_payment_v2(args)
    end

    def pay(args)
      args[:timeout_seconds] ||= 60
      router.send_payment_v2(args)
    end

    def inspect
      "#{self.to_s} @address=\"#{self.address}\""
    end

  end
end
