hosts = node['hosts']['list']
template "/etc/hosts" do
    source "hosts.erb"
    owner "root"
    group "root"
    mode 0644
    variables(
        :hosts => hosts,
        :hostname => node[:hostname],
        :fqdn => node[:fqdn]
    )
end
