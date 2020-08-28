module Lnrpc
  class GrpcWrapper
    attr_reader :grpc, :service

    def initialize(service:, grpc:)
      @grpc = grpc
      @service = service
    end

    def method_missing(m, *args, &block)
      if grpc.respond_to?(m)
        params = args[0]

        args[0] = params.nil? ? request_class_for(m).new : request_class_for(m).new(params)
        grpc.send(m, *args, &block)
      else
        super
      end
    end

    def inspect
      "#{self} @grpc=\"#{grpc}\""
    end

    private

    def request_class_for(method_name)
      rpc_desc = service.rpc_descs[camelize(method_name).to_sym]
      raise "Request class not found for: #{method_name}" unless rpc_desc

      rpc_desc.input
    end

    def camelize(name)
      str = name.to_s
      separators = ['_', '\s']
      separators.each do |s|
        str = str.gsub(/(?:#{s}+)([a-z])/) { $1.upcase }
      end
      str.gsub(/(\A|\s)([a-z])/) { $1 + $2.upcase }
    end
  end
end
