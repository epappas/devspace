node_name 'server'
base = '/opt/chef/devspace'

chef_zero.enabled true
file_cache_path base
nodes_path File.join(base, 'nodes')
role_path File.join(base, 'roles')
data_bag_path File.join(base, 'data_bags')
environment_path File.join(base, 'environments')
environment 'dev'
# encrypted_data_bag_secret File.join(base, 'data_bag_key')
# json_attribs '/opt/chef/devspace/.chef/server.json'

cookbook_path []
cookbook_path << File.join(base, 'cookbooks')
# cookbook_path << File.join(base, 'domain-cookbooks')

# ssl_verify_mode :verify_peer
