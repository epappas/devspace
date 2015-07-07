conf = node['nginx']['conf']
template "/etc/nginx/nginx.conf" do
    source "nginx.conf.erb"
    owner "root"
    group "root"
    mode 644
    variables(
        :conf => conf
    )
end

service "nginx" do
  action [ :enable, :reload ]
end
