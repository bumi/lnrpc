
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "lnrpc/version"

Gem::Specification.new do |spec|
  spec.name          = "lnrpc"
  spec.version       = Lnrpc::VERSION
  spec.authors       = ["Michael Bumann"]
  spec.email         = ["hello@michaelbumann.com"]

  spec.summary       = %q{gRPC interface for lnd packed as ruby gem}
  spec.description   = %q{gRPC service definitions for the Lightning Network Daemon (lnd) gRPC interface packed as ruby gem}
  spec.homepage      = "https://github.com/bumi/lnrpc"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "grpc", ">= 1.19.0"
  spec.add_dependency "google-protobuf", ">=3.7"
end
