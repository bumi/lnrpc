require "grpc"

module Lnrpc
  class MacaroonInterceptor < GRPC::ClientInterceptor
    def initialize(macaroon_hex)
      @macaroon = macaroon_hex
    end

    def inject_macaroon_metadata(request:, call:, method:, metadata:)
      if !metadata.has_key?('macaroon') && !metadata.has_key?(:macaroon)
        metadata[:macaroon] = @macaroon
      end
      yield
    end

    alias :request_response :inject_macaroon_metadata
    alias :client_streamer :inject_macaroon_metadata
    alias :server_streamer :inject_macaroon_metadata
    alias :bidi_streamer :inject_macaroon_metadata

  end
end
