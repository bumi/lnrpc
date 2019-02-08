module Lnrpc
  class Client
    attr_accessor :address, :credentials, :macaroon, :grpc_client

    DEFAULT_ADDRESS = 'localhost:10009'
    DEFAULT_CREDENTIALS_PATH = "~/.lnd/tls.cert"
    DEFAULT_MACAROON_PATH = "~/.lnd/data/chain/bitcoin/testnet/admin.macaroon"

    def initialize(options)
      self.address = options[:address] || DEFAULT_ADDRESS

      options[:credentials] ||= ::File.read(::File.expand_path(options[:credentials_path] || DEFAULT_CREDENTIALS_PATH))
      self.credentials = options[:credentials]

      options[:macaroon] ||= begin
        macaroon_binary = ::File.read(::File.expand_path(options[:macaroon_path] || DEFAULT_MACAROON_PATH))
        macaroon_binary.each_byte.map { |b| b.to_s(16).rjust(2,'0') }.join
      end
      self.macaroon = options[:macaroon]

      self.grpc_client = Lnrpc::Lightning::Stub.new(self.address, GRPC::Core::ChannelCredentials.new(self.credentials))
    end

    def method_missing(m, *args, &block)
      if args.last.is_a?(Hash)
        args[-1][:metadata] ||= {}
        args[-1][:metadata].merge!(macaroon: self.macaroon)
      else
        args.push({metadata: { macaroon: self.macaroon }})
      end
      self.grpc_client.send(m, *args)
    end
  end
end

