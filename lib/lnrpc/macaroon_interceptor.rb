require "grpc"

module Lnrpc
  class MacaroonInterceptor < GRPC::ClientInterceptor
    def initialize(macaroon_hex)
      @macaroon = macaroon_hex
    end

    def request_response(request:, call:, method:, metadata:)
      metadata['macaroon'] = @macaroon
      yield
    end
  end
end
