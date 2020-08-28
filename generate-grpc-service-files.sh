#!/bin/sh
set -o xtrace

FULL_PATH=$(realpath $0)
GEM_DIR=$(dirname $FULL_PATH)
LNRPC_TARGET_DIR="$GEM_DIR/lib/grpc_services"
CURRENT_DIR=$(pwd)
echo $CURRENT_DIR
cd $GOPATH/src/github.com/lightningnetwork/lnd/lnrpc

echo "Generating Ruby GRPC Service Files"

PROTOS="rpc.proto walletunlocker.proto **/*.proto"

# generate files for each proto
for file in $PROTOS; do
  DIRECTORY=$(dirname "${file}")
  echo "Generating protos from ${file}, into ${LNRPC_TARGET_DIR}/${DIRECTORY}"

  # writes all ruby files in the ruby directory
  grpc_tools_ruby_protoc -I/usr/local/include \
    -I. \
    -I$GOPATH/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
    -I$GOPATH/src/github.com/lightningnetwork/lnd/lnrpc \
    --ruby_out=plugins=grpc,paths=source_relative:${LNRPC_TARGET_DIR} \
    --grpc_out=${LNRPC_TARGET_DIR} "${file}"

done

cd $CURRENT_DIR
