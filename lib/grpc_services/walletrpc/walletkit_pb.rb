# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: walletrpc/walletkit.proto

require 'google/protobuf'

require 'rpc_pb'
require 'signrpc/signer_pb'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("walletrpc/walletkit.proto", :syntax => :proto3) do
    add_message "walletrpc.ListUnspentRequest" do
      optional :min_confs, :int32, 1
      optional :max_confs, :int32, 2
      optional :account, :string, 3
      optional :unconfirmed_only, :bool, 4
    end
    add_message "walletrpc.ListUnspentResponse" do
      repeated :utxos, :message, 1, "lnrpc.Utxo"
    end
    add_message "walletrpc.LeaseOutputRequest" do
      optional :id, :bytes, 1
      optional :outpoint, :message, 2, "lnrpc.OutPoint"
      optional :expiration_seconds, :uint64, 3
    end
    add_message "walletrpc.LeaseOutputResponse" do
      optional :expiration, :uint64, 1
    end
    add_message "walletrpc.ReleaseOutputRequest" do
      optional :id, :bytes, 1
      optional :outpoint, :message, 2, "lnrpc.OutPoint"
    end
    add_message "walletrpc.ReleaseOutputResponse" do
    end
    add_message "walletrpc.KeyReq" do
      optional :key_finger_print, :int32, 1
      optional :key_family, :int32, 2
    end
    add_message "walletrpc.AddrRequest" do
      optional :account, :string, 1
      optional :type, :enum, 2, "walletrpc.AddressType"
      optional :change, :bool, 3
    end
    add_message "walletrpc.AddrResponse" do
      optional :addr, :string, 1
    end
    add_message "walletrpc.Account" do
      optional :name, :string, 1
      optional :address_type, :enum, 2, "walletrpc.AddressType"
      optional :extended_public_key, :string, 3
      optional :master_key_fingerprint, :bytes, 4
      optional :derivation_path, :string, 5
      optional :external_key_count, :uint32, 6
      optional :internal_key_count, :uint32, 7
      optional :watch_only, :bool, 8
    end
    add_message "walletrpc.ListAccountsRequest" do
      optional :name, :string, 1
      optional :address_type, :enum, 2, "walletrpc.AddressType"
    end
    add_message "walletrpc.ListAccountsResponse" do
      repeated :accounts, :message, 1, "walletrpc.Account"
    end
    add_message "walletrpc.ImportAccountRequest" do
      optional :name, :string, 1
      optional :extended_public_key, :string, 2
      optional :master_key_fingerprint, :bytes, 3
      optional :address_type, :enum, 4, "walletrpc.AddressType"
      optional :dry_run, :bool, 5
    end
    add_message "walletrpc.ImportAccountResponse" do
      optional :account, :message, 1, "walletrpc.Account"
      repeated :dry_run_external_addrs, :string, 2
      repeated :dry_run_internal_addrs, :string, 3
    end
    add_message "walletrpc.ImportPublicKeyRequest" do
      optional :public_key, :bytes, 1
      optional :address_type, :enum, 2, "walletrpc.AddressType"
    end
    add_message "walletrpc.ImportPublicKeyResponse" do
    end
    add_message "walletrpc.Transaction" do
      optional :tx_hex, :bytes, 1
      optional :label, :string, 2
    end
    add_message "walletrpc.PublishResponse" do
      optional :publish_error, :string, 1
    end
    add_message "walletrpc.SendOutputsRequest" do
      optional :sat_per_kw, :int64, 1
      repeated :outputs, :message, 2, "signrpc.TxOut"
      optional :label, :string, 3
      optional :min_confs, :int32, 4
      optional :spend_unconfirmed, :bool, 5
    end
    add_message "walletrpc.SendOutputsResponse" do
      optional :raw_tx, :bytes, 1
    end
    add_message "walletrpc.EstimateFeeRequest" do
      optional :conf_target, :int32, 1
    end
    add_message "walletrpc.EstimateFeeResponse" do
      optional :sat_per_kw, :int64, 1
    end
    add_message "walletrpc.PendingSweep" do
      optional :outpoint, :message, 1, "lnrpc.OutPoint"
      optional :witness_type, :enum, 2, "walletrpc.WitnessType"
      optional :amount_sat, :uint32, 3
      optional :sat_per_byte, :uint32, 4
      optional :broadcast_attempts, :uint32, 5
      optional :next_broadcast_height, :uint32, 6
      optional :requested_conf_target, :uint32, 8
      optional :requested_sat_per_byte, :uint32, 9
      optional :sat_per_vbyte, :uint64, 10
      optional :requested_sat_per_vbyte, :uint64, 11
      optional :force, :bool, 7
    end
    add_message "walletrpc.PendingSweepsRequest" do
    end
    add_message "walletrpc.PendingSweepsResponse" do
      repeated :pending_sweeps, :message, 1, "walletrpc.PendingSweep"
    end
    add_message "walletrpc.BumpFeeRequest" do
      optional :outpoint, :message, 1, "lnrpc.OutPoint"
      optional :target_conf, :uint32, 2
      optional :sat_per_byte, :uint32, 3
      optional :force, :bool, 4
      optional :sat_per_vbyte, :uint64, 5
    end
    add_message "walletrpc.BumpFeeResponse" do
    end
    add_message "walletrpc.ListSweepsRequest" do
      optional :verbose, :bool, 1
    end
    add_message "walletrpc.ListSweepsResponse" do
      oneof :sweeps do
        optional :transaction_details, :message, 1, "lnrpc.TransactionDetails"
        optional :transaction_ids, :message, 2, "walletrpc.ListSweepsResponse.TransactionIDs"
      end
    end
    add_message "walletrpc.ListSweepsResponse.TransactionIDs" do
      repeated :transaction_ids, :string, 1
    end
    add_message "walletrpc.LabelTransactionRequest" do
      optional :txid, :bytes, 1
      optional :label, :string, 2
      optional :overwrite, :bool, 3
    end
    add_message "walletrpc.LabelTransactionResponse" do
    end
    add_message "walletrpc.FundPsbtRequest" do
      optional :account, :string, 5
      optional :min_confs, :int32, 6
      optional :spend_unconfirmed, :bool, 7
      oneof :template do
        optional :psbt, :bytes, 1
        optional :raw, :message, 2, "walletrpc.TxTemplate"
      end
      oneof :fees do
        optional :target_conf, :uint32, 3
        optional :sat_per_vbyte, :uint64, 4
      end
    end
    add_message "walletrpc.FundPsbtResponse" do
      optional :funded_psbt, :bytes, 1
      optional :change_output_index, :int32, 2
      repeated :locked_utxos, :message, 3, "walletrpc.UtxoLease"
    end
    add_message "walletrpc.TxTemplate" do
      repeated :inputs, :message, 1, "lnrpc.OutPoint"
      map :outputs, :string, :uint64, 2
    end
    add_message "walletrpc.UtxoLease" do
      optional :id, :bytes, 1
      optional :outpoint, :message, 2, "lnrpc.OutPoint"
      optional :expiration, :uint64, 3
      optional :pk_script, :bytes, 4
      optional :value, :uint64, 5
    end
    add_message "walletrpc.SignPsbtRequest" do
      optional :funded_psbt, :bytes, 1
    end
    add_message "walletrpc.SignPsbtResponse" do
      optional :signed_psbt, :bytes, 1
    end
    add_message "walletrpc.FinalizePsbtRequest" do
      optional :funded_psbt, :bytes, 1
      optional :account, :string, 5
    end
    add_message "walletrpc.FinalizePsbtResponse" do
      optional :signed_psbt, :bytes, 1
      optional :raw_final_tx, :bytes, 2
    end
    add_message "walletrpc.ListLeasesRequest" do
    end
    add_message "walletrpc.ListLeasesResponse" do
      repeated :locked_utxos, :message, 1, "walletrpc.UtxoLease"
    end
    add_enum "walletrpc.AddressType" do
      value :UNKNOWN, 0
      value :WITNESS_PUBKEY_HASH, 1
      value :NESTED_WITNESS_PUBKEY_HASH, 2
      value :HYBRID_NESTED_WITNESS_PUBKEY_HASH, 3
      value :TAPROOT_PUBKEY, 4
    end
    add_enum "walletrpc.WitnessType" do
      value :UNKNOWN_WITNESS, 0
      value :COMMITMENT_TIME_LOCK, 1
      value :COMMITMENT_NO_DELAY, 2
      value :COMMITMENT_REVOKE, 3
      value :HTLC_OFFERED_REVOKE, 4
      value :HTLC_ACCEPTED_REVOKE, 5
      value :HTLC_OFFERED_TIMEOUT_SECOND_LEVEL, 6
      value :HTLC_ACCEPTED_SUCCESS_SECOND_LEVEL, 7
      value :HTLC_OFFERED_REMOTE_TIMEOUT, 8
      value :HTLC_ACCEPTED_REMOTE_SUCCESS, 9
      value :HTLC_SECOND_LEVEL_REVOKE, 10
      value :WITNESS_KEY_HASH, 11
      value :NESTED_WITNESS_KEY_HASH, 12
      value :COMMITMENT_ANCHOR, 13
    end
  end
end

module Walletrpc
  ListUnspentRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.ListUnspentRequest").msgclass
  ListUnspentResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.ListUnspentResponse").msgclass
  LeaseOutputRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.LeaseOutputRequest").msgclass
  LeaseOutputResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.LeaseOutputResponse").msgclass
  ReleaseOutputRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.ReleaseOutputRequest").msgclass
  ReleaseOutputResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.ReleaseOutputResponse").msgclass
  KeyReq = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.KeyReq").msgclass
  AddrRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.AddrRequest").msgclass
  AddrResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.AddrResponse").msgclass
  Account = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.Account").msgclass
  ListAccountsRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.ListAccountsRequest").msgclass
  ListAccountsResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.ListAccountsResponse").msgclass
  ImportAccountRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.ImportAccountRequest").msgclass
  ImportAccountResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.ImportAccountResponse").msgclass
  ImportPublicKeyRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.ImportPublicKeyRequest").msgclass
  ImportPublicKeyResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.ImportPublicKeyResponse").msgclass
  Transaction = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.Transaction").msgclass
  PublishResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.PublishResponse").msgclass
  SendOutputsRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.SendOutputsRequest").msgclass
  SendOutputsResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.SendOutputsResponse").msgclass
  EstimateFeeRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.EstimateFeeRequest").msgclass
  EstimateFeeResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.EstimateFeeResponse").msgclass
  PendingSweep = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.PendingSweep").msgclass
  PendingSweepsRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.PendingSweepsRequest").msgclass
  PendingSweepsResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.PendingSweepsResponse").msgclass
  BumpFeeRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.BumpFeeRequest").msgclass
  BumpFeeResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.BumpFeeResponse").msgclass
  ListSweepsRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.ListSweepsRequest").msgclass
  ListSweepsResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.ListSweepsResponse").msgclass
  ListSweepsResponse::TransactionIDs = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.ListSweepsResponse.TransactionIDs").msgclass
  LabelTransactionRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.LabelTransactionRequest").msgclass
  LabelTransactionResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.LabelTransactionResponse").msgclass
  FundPsbtRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.FundPsbtRequest").msgclass
  FundPsbtResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.FundPsbtResponse").msgclass
  TxTemplate = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.TxTemplate").msgclass
  UtxoLease = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.UtxoLease").msgclass
  SignPsbtRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.SignPsbtRequest").msgclass
  SignPsbtResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.SignPsbtResponse").msgclass
  FinalizePsbtRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.FinalizePsbtRequest").msgclass
  FinalizePsbtResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.FinalizePsbtResponse").msgclass
  ListLeasesRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.ListLeasesRequest").msgclass
  ListLeasesResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.ListLeasesResponse").msgclass
  AddressType = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.AddressType").enummodule
  WitnessType = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("walletrpc.WitnessType").enummodule
end
