# Lnrpc - ruby gRPC client for LND

a [gRPC](https://grpc.io/) client for [LND, the Lightning Network Daemon](https://github.com/lightningnetwork/lnd/) packed as ruby gem.

Currently published as [beta release](https://rubygems.org/gems/lnrpc) to rubygems for LND v0.5.2.beta. (see [#Versioning](#Versioning))


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lnrpc'
```

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

# the gRPC client is available under the Lnrpc namespace, e.g. 

Lnrpc::Lightning::Stub
Lnrpc::GetInfoRequest
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
```

### Client wrapper

An optional client wrapper ([Lnrpc::Client](https://github.com/bumi/lnrpc/blob/master/lib/lnrpc/client.rb)) makes 
initializing the gRPC client easier and removes the need for some boilerplate code for calling RPC methods.

#### Example
```ruby
lnd = Lnrpc::Client.new({credentials_path: '/path/to.cert.cls', macaroon_path: '/path/to/admin.macaroon'})
lnd.get_info
```

Also have a look at [examples.rb](https://github.com/bumi/lnrpc/blob/master/examples.rb)

#### Initializing a new client

The Lnrpc::Client constructor allows the following options: 

* credentials: 
  - `credentials` : the credentials data as string
  - `credentials_path` : the path to a credentials file (tls.cert) as string (default: `"#{LND_HOME_DIR}/tls.cert"` )
* macaroon: 
  - `macaroon` : the macaroon as hex string
  - `macaroon_path` : the path to the macaroon file created by lnd as string (default: `"#{LND_HOME_DIR}/data/chain/bitcoin/mainnet/admin.macaroon"`)
* address:
  - `address` : lnd address as string. format: address:port, e.g. localhost:10009 (default)

If no credentials or no macaroon is provied defaults files are assumed in `ENV['LND_HOME'] || "~/.lnd"`.  
A macaroon is required.

```ruby
require 'lnrpc'

lnd = Lnrpc::Client.new({
  credentials_path: '/path/to.cert.cls', 
  macaroon_path: '/path/to/admin.macaroon',
  address: 'host:port'
})

# the actual gRPC client is available through:
lnd.grpc_client
```

#### Calling RPC methods

The client wrapper passes any supported RPC method call to the gRPC client applying the following conventions:

If the first parameter is a hash or blank the corresponding gRPC request object will be instantiated. 

Example:

```ruby
client.get_info
# is the same as: 
client.grpc_client.get_info(Lnrpc::GetInfoRequest.new)

client.list_channels(inactive_only: true)
# is the same as: 
request = Lnrpc::ListChannelsRequest.new(inactive_only: true)
client.grpc_client.list_channels(request)

client.wallet_balance.total_balance
# is the same as: 
request = Lnrpc::WalletBalanceRequest.new()
client.grpc_client.wallet_balance(request).total_balance
```


## Versioning

This gem follows the LND versions and will update the gRPC service definitions accordingly. 
e.g. gem version 0.5.2 includes the gRPC service definitions from LND v0.5.2


## Other resources

* [LND gRPC API Reference](https://api.lightning.community)
* [LND Developer Site](https://dev.lightning.community/)
* [gRPC Ruby quick start](https://grpc.io/docs/quickstart/ruby.html)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bumi/lnrpc.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
