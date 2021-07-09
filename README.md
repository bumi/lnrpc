# Lnrpc - ruby gRPC client for LND
[![Gem Version](https://badge.fury.io/rb/lnrpc.svg)](https://badge.fury.io/rb/lnrpc)

a [gRPC](https://grpc.io/) client for [LND, the Lightning Network Daemon](https://github.com/lightningnetwork/lnd/) packed as ruby gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lnrpc', '~> 0.13.0'
```
lnrpc follows the lnd versioning, thus it is recommended to specify the exact version you need for your lnd node as dependency (see [#Versioning](#Versioning)).

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lnrpc
    # or for pre releases:
    $ gem install lnrcp --pre

## Usage

This gem makes the gRPC client classes created from the [LND service defintions](https://github.com/lightningnetwork/lnd/tree/master/lnrpc) available.  

```ruby
require "lnrpc"

# With the changes in LND v.10.0 this load the `Lnrpc` and `Routerrpc` namespace

Lnrpc::Lightning::Stub
Routerrpc:::Routerrpc::Stub
Lnrpc::GetInfoRequest
...
```

Learn more about [gRPC](https://grpc.io/) on [gRPC.io](https://grpc.io/).

The LND API reference can be found here: [https://api.lightning.community/](https://api.lightning.community/)

### Example

```ruby
require "lnrpc"

credentials = File.read("/path/to/tls.cert")
macaroon = File.read("/path/to/readonly.macaroon").unpack("H*")

# initialize a new client
client = Lnrpc::Lightning::Stub.new("localhost:10009", GRPC::Core::ChannelCredentials.new(self.credentials))

# perform a request
request = Lnrpc::GetInfoRequest.new
response = client.get_info(request, { metadata: { macaroon: macaroon } }) #=> Lnrpc::GetInfoResponse
puts response.alias

router = Routerprc::Router::Stub.new("localhost:10009", GRPC::Core::ChannelCredentials.new(self.credentials))
...

```

### Client wrapper

NOTE: v10.0 has breaking changes!

An optional client wrapper ([Lnrpc::Client](https://github.com/bumi/lnrpc/blob/master/lib/lnrpc/client.rb)) makes
initializing the gRPC client easier and removes the need for some boilerplate code for calling RPC methods.

#### Example
```ruby
lnd = Lnrpc::Client.new({credentials_path: '/path/to.cert.cls', macaroon_path: '/path/to/admin.macaroon'})
lnd.lightning # => Lnrpc::Lightning::Stub
lnd.router # => Lnrpc::Router::Stub

lnd.ligthning.get_info
```

Also have a look at [examples.rb](https://github.com/bumi/lnrpc/blob/master/examples.rb)

#### Initializing a new client

The Lnrpc::Client constructor allows the following options:

* credentials:
  - `credentials` : the credentials data as string (pass nil if a "trusted" cert (e.g. from letsencrypt is used)
  - `credentials_path` : the path to a credentials file (tls.cert) as string (default: `"#{LND_HOME_DIR}/tls.cert"` )
* macaroon:
  - `macaroon` : the macaroon as hex string
  - `macaroon_path` : the path to the macaroon file created by lnd as string (default: `"#{LND_HOME_DIR}/data/chain/bitcoin/mainnet/admin.macaroon"`)
* address:
  - `address` : lnd address as string. format: address:port, e.g. localhost:10009 (default)

If no credentials or no macaroon is provided default files are assumed in `ENV['LND_HOME'] || "~/.lnd"`.
A macaroon is required.

```ruby
require 'lnrpc'

lnd = Lnrpc::Client.new({
  credentials_path: '/path/to.cert.cls',
  macaroon_path: '/path/to/admin.macaroon',
  address: 'host:port'
})

# the actual gRPC client is available through:
lnd.lightning.grpc
lnd.router.grpc
```

#### Calling RPC methods

The client wrapper passes any supported RPC method call to the gRPC client applying the following conventions:

If the first parameter is a hash or blank the corresponding gRPC request object will be instantiated.

Example:

```ruby
client.lightning.get_info
# is the same as:
client.lightning.grpc.get_info(Lnrpc::GetInfoRequest.new)

client.lightning.list_channels(inactive_only: true)
# is the same as:
request = Lnrpc::ListChannelsRequest.new(inactive_only: true)
client.lightning.grpc.list_channels(request)

client.lightning.wallet_balance.total_balance
# is the same as:
request = Lnrpc::WalletBalanceRequest.new()
client.lightning.grpc.wallet_balance(request).total_balance
```

## Using with BTC Pay Server
If you have a running BTC Pay Server with LND support, integrating with lnrpc is easy.

- Navigate to the domain associated with your BTC Pay Server
- Navigate to Services on the Server Settings page
- Click "see information" for your gRPC Server
- The link by "More details..." will expose the address and various macaroon hex strings
- Initialize your client with the options detailed above. BTC Pay Server utilizes LetsEncrypt for trusted TLC       Certificates so set that option to nil.

Don't have a BTC Pay Server? [Setting one up is easy.](https://medium.com/@BtcpayServer/launch-btcpay-server-via-web-interface-and-deploy-full-bitcoin-node-lnd-in-less-than-a-minute-dc8bc6f06a3)


## Versioning

This gem follows the LND versions and will update the gRPC service definitions accordingly.
e.g. gem version 0.5.2 includes the gRPC service definitions from LND v0.5.2

see [rubygems](https://rubygems.org/gems/lnrpc) for all available releases.


### Update service definitions

The script `generate-grpc-service-files.sh` can be used to generate the GRPC ruby files.
The files will be stored in `lib/grpc_services`

    $ ./generate-grpc-service-files.sh

+ Make sure you have the [grpc-tools](https://rubygems.org/gems/grpc-tools) installed
+ Make sure you have the lnd source in your $GOPATH/src folder

## Other resources

* [LND gRPC API Reference](https://api.lightning.community)
* [LND Developer Site](https://dev.lightning.community/)
* [gRPC Ruby quick start](https://grpc.io/docs/quickstart/ruby.html)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bumi/lnrpc.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
