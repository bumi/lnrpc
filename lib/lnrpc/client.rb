module Lnrpc
  class Client
    attr_accessor :address, :credentials, :macaroon, :grpc_client

    LND_HOME_DIR = ENV['LND_HOME'] || "~/.lnd"
    DEFAULT_ADDRESS = 'localhost:10009'
    DEFAULT_CREDENTIALS_PATH = "#{LND_HOME_DIR}/tls.cert"
    DEFAULT_MACAROON_PATH = "#{LND_HOME_DIR}/data/chain/bitcoin/mainnet/admin.macaroon"

    def initialize(options={})
      self.address = options[:address] || DEFAULT_ADDRESS

      options[:credentials] ||= ::File.read(::File.expand_path(options[:credentials_path] || DEFAULT_CREDENTIALS_PATH))
      self.credentials = options[:credentials]

      options[:macaroon] ||= begin
        macaroon_binary = ::File.read(::File.expand_path(options[:macaroon_path] || DEFAULT_MACAROON_PATH))
        macaroon_binary.unpack("H*")
      end
      self.macaroon = options[:macaroon]

      self.grpc_client = Lnrpc::Lightning::Stub.new(self.address, GRPC::Core::ChannelCredentials.new(self.credentials))
    end

    def pay(payreq)
      self.send_payment_sync(Lnrpc::SendRequest.new(payment_request: payreq))
    end

    def method_missing(m, *args, &block)
      if self.grpc_client.respond_to?(m)
        params  = args[0]
        options = args[1] || { metadata: { macaroon: self.macaroon } }

        request = params.nil? ? request_class_for(m).new : request_class_for(m).new(params)
        self.grpc_client.send(m, request, options)
      else
        super
      end
    end

    private
    def request_class_for(method_name)
      string = method_name.to_s.sub(/^[a-z\d]*/) { |match| match.capitalize }
      string.gsub!(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
      Lnrpc.const_get("#{string}Request")
    end
  end
end

