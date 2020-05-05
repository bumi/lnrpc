module Lnrpc
  class GrpcWrapper
    NON_CONVENTION_REQUEST_CLASSES = {
      add_invoice: Lnrpc::Invoice,
      decode_pay_req: Lnrpc::PayReqString,
      describe_graph: Lnrpc::ChannelGraphRequest,
      export_all_channel_backups: Lnrpc::ChanBackupExportRequest,
      funding_state_step: Lnrpc::FundingTransitionMsg,
      get_chan_info: Lnrpc::ChanInfoRequest,
      get_network_info: Lnrpc::NetworkInfoRequest,
      get_node_info: Lnrpc::NodeInfoRequest,
      get_node_metrics: Lnrpc::NodeMetricsRequest,
      lookup_invoice: Lnrpc::PaymentHash,
      open_channel_sync: Lnrpc::OpenChannelRequest,
      send_payment_sync: Lnrpc::SendRequest,
      send_to_route_sync: Lnrpc::SendToRouteRequest,
      stop_daemon: Lnrpc::StopRequest,
      subscribe_channel_backups: Lnrpc::ChannelBackupSubscription,
      subscribe_channel_event: Lnrpc::ChannelEventSubscription,
      subscribe_channel_graph: Lnrpc::GraphTopologySubscription,
      subscribe_invoices: Lnrpc::InvoiceSubscription,
      subscribe_peer_event: Lnrpc::PeerEventSubscription,
      subscribe_transactions: Lnrpc::GetTransactionsRequest,
      update_channel_policy: Lnrpc::PolicyUpdateResponse,
      varify_channel_backup: Lnrpc::ChanBackupSnapshot,

      estimate_route_fee: Routerrpc::RouteFeeRequest,
      send_payment: Routerrpc::SendPaymentRequest,
      send_payment_v2: Routerrpc::SendPaymentRequest,
      track_payment_v2: Routerrpc::TrackPaymentRequest
    }

    attr_reader :grpc

    def initialize(grpc)
      @grpc = grpc
    end

    def method_missing(m, *args, &block)
      if self.grpc.respond_to?(m)
        params  = args[0]

        args[0] = params.nil? ? request_class_for(m).new : request_class_for(m).new(params)
        self.grpc.send(m, *args, &block)
      else
        super
      end
    end

    def inspect
      "#{self.to_s} @grpc=\"#{self.grpc.to_s}\""
    end

    private

    def request_class_for(method_name)
      if NON_CONVENTION_REQUEST_CLASSES.key?(method_name.to_sym)
        NON_CONVENTION_REQUEST_CLASSES[method_name.to_sym]
      else
        klass = method_name.to_s.sub(/^[a-z\d]*/) { |match| match.capitalize }
        klass.gsub!(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
        Module.const_get(grpc.class.name.to_s[/.+?(?=::)/]).const_get("#{klass}Request")
      end
    end
  end
end
