source 'https://supermarket.chef.io/'

Dir.glob(File.expand_path('/opt/chef/devspace/domain-cookbooks/*', __FILE__)).each do |path|
    metadata path: path
end

# Add cookbooks that added directly (not mentioned as dependency in metadata)
cookbook 'build-essential', '= 2.2.3'
cookbook 'apt'
cookbook 'database'
cookbook 'iptables', '= 0.13.2'
cookbook 'nodejs'
cookbook 'windows', '~> 1.34.8'
cookbook 'aerospike', '~> 0.0.12'
cookbook 'git', '~> 4.2.2'
cookbook 'java'
cookbook 'couchdb', '~> 2.5.0'
cookbook 'erlang'
cookbook 'nginx', '~> 2.7.6'
cookbook 'mysql', '~> 6.0'
cookbook 'docker', '~> 0.43.0'
cookbook 'rustlang', '~> 0.1.3'
cookbook 'golang', '~> 1.7.0'
cookbook 'chef-bitcoind', '~> 0.1.8'
cookbook 'postgresql', '~> 4.0.6'
cookbook 'rabbitmq', '~> 4.10.0'
cookbook 'poise-python', '~> 1.5.1'
cookbook 'redis', '~> 3.0.4'
