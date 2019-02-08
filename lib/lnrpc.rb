require "lnrpc/version"

module Lnrpc
  class Error < StandardError; end
  autoload :WalletUnlocker, 'lnrpc/rpc_services_pb'
  autoload :Lightning, 'lnrpc/rpc_services_pb'
  autoload :Client, 'lnrpc/client'
end
