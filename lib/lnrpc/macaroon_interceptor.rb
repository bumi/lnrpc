require "grpc"

module Lnrpc
  class MacaroonInterceptor < GRPC::ClientInterceptor
    def initialize(macaroon_hex)
      @macaroon = macaroon_hex
    end

    def request_response(request:, call:, method:, metadata:)
      if !metadata.has_key?('macaroon') && !metadata.has_key?(:macaroon)
        metadata[:macaroon] = @macaroon
      end
      yield
    end
  end
end
