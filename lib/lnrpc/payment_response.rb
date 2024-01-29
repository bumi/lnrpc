module Lnrpc
  class PaymentResponse
    attr_reader :grpc_response, :exception

    def initialize(send_payment_response)
      @grpc_response = send_payment_response
    end

    def states
      @states ||= response_array.map(&:status)
    end

    def success?
      return false if exception

      @success ||= states.include?(:SUCCEEDED)
    end

    def fee
      @fee ||= response_array.sum(&:fee)
    end

    def response_array
      @response_array ||= @grpc_response.to_a
    rescue GRPC::BadStatus => e
      @exception = e
      []
    end
  end
end
