template "/usr/local/bin/force-npm-install" do
    source "force-npm-install.erb"
    owner "root"
    group "root"
    mode 0755
end
