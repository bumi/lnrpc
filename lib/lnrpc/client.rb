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
      @lightning ||= grpc_wrapper_for(Lnrpc::Lightning)
    end

    def autopilot
      @autopilot ||= grpc_wrapper_for(Autopilotrpc::Autopilot)
    end

    def chain_notifier
      @chain_notifier ||= grpc_wrapper_for(Chainrpc::ChainNotifier)
    end

    def invoices
      @invoices ||= grpc_wrapper_for(Invoicesrpc::Invoices)
    end

    def router
      @router ||= grpc_wrapper_for(Routerrpc::Router)
    end

    def signer
      @signer ||= grpc_wrapper_for(Signrpc::Signer)
    end

    def versioner
      @versioner ||= grpc_wrapper_for(Verrpc::Versioner)
    end

    def wallet_kit
      @wallet_kit ||= grpc_wrapper_for(Walletrpc::WalletKit)
    end

    def wallet_unlocker
      @wallet_unlocker ||= grpc_wrapper_for(Lnrpc::WalletUnlocker)
    end

    def watchtower
      @watchtower ||= grpc_wrapper_for(Watchtowerrpc::Watchtower)
    end

    def watchtower_client
      @watchtower_client ||= grpc_wrapper_for(Wtclientrpc::WatchtowerClient)
    end

    def keysend(args)
      args[:dest_custom_records] ||= {}
      args[:dest_custom_records][Lnrpc::KEY_SEND_PREIMAGE_TYPE] ||= Lnrpc.create_preimage
      args[:payment_hash] ||= Digest::SHA256.digest(args[:dest_custom_records][Lnrpc::KEY_SEND_PREIMAGE_TYPE])
      args[:timeout_seconds] ||= 60
      PaymentResponse.new(router.send_payment_v2(args))
    end

    def pay(args)
      args[:timeout_seconds] ||= 60
      PaymentResponse.new(router.send_payment_v2(args))
    end

    def inspect
      "#{self} @address=\"#{address}\""
    end

    private

    def grpc_wrapper_for(grpc_module)
      stub = grpc_module.const_get(:Stub)
      service = grpc_module.const_get(:Service)
      GrpcWrapper.new(service: service,
                      grpc: stub.new(address,
                                GRPC::Core::ChannelCredentials.new(credentials),
                                interceptors: [Lnrpc::MacaroonInterceptor.new(macaroon)]
                              ))
    end
  end
end
