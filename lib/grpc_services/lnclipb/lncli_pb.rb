# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: lnclipb/lncli.proto

require 'google/protobuf'

require 'verrpc/verrpc_pb'
Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("lnclipb/lncli.proto", :syntax => :proto3) do
    add_message "lnclipb.VersionResponse" do
      optional :lncli, :message, 1, "verrpc.Version"
      optional :lnd, :message, 2, "verrpc.Version"
    end
  end
end

module Lnclipb
  VersionResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("lnclipb.VersionResponse").msgclass
end