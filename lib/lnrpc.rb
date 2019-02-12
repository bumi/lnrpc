require "lnrpc/version"
require "lnrpc/rpc_services_pb"

module Lnrpc
  class Error < StandardError; end
  autoload :Client, 'lnrpc/client'
end


