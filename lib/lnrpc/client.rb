module Lnrpc
  class Client
    attr_accessor :address, :credentials, :macaroon, :grpc_client

    LND_HOME_DIR = ENV['LND_HOME'] || "~/.lnd"
    DEFAULT_ADDRESS = 'localhost:10009'
    DEFAULT_CREDENTIALS_PATH = "#{LND_HOME_DIR}/tls.cert"
    DEFAULT_MACAROON_PATH = "#{LND_HOME_DIR}/data/chain/bitcoin/mainnet/admin.macaroon"

    NON_CONVENTION_REQUEST_CLASSES = {
      add_invoice: Lnrpc::Invoice,
      send_payment: Lnrpc::SendRequest,
      send_payment_sync: Lnrpc::SendRequest,
      open_channel_sync: Lnrpc::OpenChannelRequest,
      send_to_route_sync: Lnrpc::SendToRouteRequest,
      lookup_invoice: Lnrpc::PaymentHash,
      decode_pay_req: Lnrpc::PayReqString,
      describe_graph: Lnrpc::ChannelGraphRequest,
      get_chan_info: Lnrpc::ChanInfoRequest,
      get_node_info: Lnrpc::NodeInfoRequest,
      get_network_info: Lnrpc::NetworkInfoRequest,
      stop_daemon: Lnrpc::StopRequest,
      update_channel_policy: Lnrpc::PolicyUpdateResponse,
      subscribe_channel_graph: Lnrpc::GraphTopologySubscription,
      subscribe_invoices: Lnrpc::InvoiceSubscription,
      subscribe_transactions: Lnrpc::GetTransactionsRequest
    }

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
      if NON_CONVENTION_REQUEST_CLASSES.key?(method_name.to_sym)
        NON_CONVENTION_REQUEST_CLASSES[method_name.to_sym]
      else
        klass = method_name.to_s.sub(/^[a-z\d]*/) { |match| match.capitalize }
        klass.gsub!(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
        Lnrpc.const_get("#{klass}Request")
      end
    end
  end
end

