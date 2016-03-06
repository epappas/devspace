
directory '/opt/libbitcoin' do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
    not_if { File.exist?('/opt/libbitcoin') }
end

# git "/opt/libbitcoin" do
#    repository "https://github.com/libbitcoin/libbitcoin-explorer.git"
#    reference "v2.2.0"
#    action :sync
#    action :create_if_missing
#end

# remote_file '/opt/libbitcoin/install.sh' do
#   source 'https://raw.githubusercontent.com/libbitcoin/libbitcoin-explorer/version2/install.sh'
#   action :create_if_missing
# end

template "/opt/libbitcoin/install.sh" do
    source "install.sh.erb"
    owner "root"
    group "root"
    mode 0755
    not_if { File.exist?('/opt/libbitcoin/install.sh') }
end

#execute 'libbitcoin update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-4.8 50' do
#  command 'update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-4.8 50'
#  cwd '/opt/libbitcoin'
#  not_if { File.exist?('/usr/local/bin/bx') }
#end

execute 'libbitcoin ./install.sh' do
  command 'chmod +x install.sh && ./install.sh'
  cwd '/opt/libbitcoin'
  not_if { File.exist?('/usr/local/bin/bx') }
end

