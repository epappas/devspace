#
# Cookbook Name:: vm-users
# Recipe:: default
#

return if Chef::Config[:solo]

# manage groups
groups = []
begin
  groups = search(:groups, '*:*')
rescue
  Chef::Log.warn 'The groups data bag does not exist!'
end

group_to_enable_sudo = groups.select { |grp| grp['sudo'] == 'yes' }

groups.each do |grp|
  group grp['name'] ||= grp['id'] do
    group_name grp['name']
    if grp['gid']
      gid grp['gid']
      if grp['gid'].to_i < 999
        system true
      end
    end
    action :create
    not_if "getent group #{grp['name']}"
  end

  # configure group sudo access
  if grp['sudo'] == 'yes'
    sudo_groups = node.default['authorization']['sudo']['groups']
    sudo_groups << grp['name'] unless sudo_groups.include?(grp['name'])
  end
end

node.default['authorization']['sudo']['groups'] = group_to_enable_sudo.map { |grp| grp['id'] }
include_recipe 'sudo'

# manage users
users = []
begin
  users = search(:users, '*:*')
rescue
  Chef::Log.warn 'The users data bag does not exist!'
end

users.each do |usr|
  u = usr
  u['username'] ||= u['id']

  home_basedir = '/home'

  # Set home to location in data bag,
  # or a reasonable default ($home_basedir/$user).
  if u['home']
    home_dir = u['home']
  else
    home_dir = "#{home_basedir}/#{u['username']}"
  end

  # The user block will fail if the group does not yet exist.
  # See the -g option limitations in man 8 useradd for an explanation.
  # This should correct that without breaking functionality.
  if u['gid'] && u['gid'].is_a?(Numeric)
    group u['username'] do
      gid u['gid']
    end
  end

  # Create user object.
  user u['username'] do
    uid u['uid']
    if u['gid']
      gid u['gid']
    end
    shell u['shell']
    comment u['comment']
    password u['password'] if u['password']
    if home_dir == '/dev/null'
      supports manage_home: false
    else
      supports manage_home: true
    end
    home home_dir
    action u['action'] if u['action']
    not_if "getent passwd #{u['username']}"
  end

  if home_dir != '/dev/null'
    Chef::Log.debug("Managing home files for #{u['username']}")

    directory "#{home_dir}/.ssh" do
      owner u['username']
      group u['gid'] || u['username']
      mode '0700'
    end

    if u['git']
      if u['git']['config']
        template "#{home_dir}/.gitconfig" do
          source 'gitconfig.erb'
          owner u['username']
          group u['gid'] || u['username']
          mode 0644
          variables(
              config: u['git']['config']
          )
        end
      end
      template '/etc/profile.d/git-completion.sh' do
        source 'git-completion.sh.erb'
        owner 'root'
        group 'root'
        mode 0755
        variables
      end
    end

    if u['profile']
      if u['profile']['config']
        template "#{home_dir}/.bash_profile" do
          source 'bash_profile.erb'
          owner u['username']
          group u['gid'] || u['username']
          mode 0644
          variables(
              gitconfig: u['git']['config'],
              config: u['profile']['config']
          )
        end
        template '/etc/profile.d/complete-hosts.sh' do
          source 'complete-hosts.sh.erb'
          owner 'root'
          group 'root'
          mode 0755
          variables
        end
      end
    end

    if u['ssh']
      if u['ssh']['authorized_keys']
        template "#{home_dir}/.ssh/authorized_keys.chef" do
          source 'authorized_keys.erb'
          owner u['username']
          group u['gid'] || u['username']
          mode '0600'
          variables ssh_keys: u['ssh']['authorized_keys']
        end

        execute 'Copy authorized_keys to tmp' do
          user 'root'
          command "cat #{home_dir}/.ssh/authorized_keys >> #{home_dir}/.ssh/authorized_keys.chef"
          only_if { File.exist?("#{home_dir}/.ssh/authorized_keys") }
        end

        execute 'Unique keys to auth keys only' do
          user 'root'
          command "sort #{home_dir}/.ssh/authorized_keys.chef | uniq > #{home_dir}/.ssh/authorized_keys"
        end
      end

      if u['ssh']['private_keys']
        u['ssh']['private_keys'].each do |key_name, key_val|
          template "#{home_dir}/.ssh/#{key_name}" do
            source 'private_key.erb'
            owner u['id']
            group u['gid'] || u['id']
            mode '0400'
            variables private_key: key_val
          end
        end
      end

      if u['ssh']['public_keys']
        u['ssh']['public_keys'].each do |key_name, key_val|
          template "#{home_dir}/.ssh/#{key_name}" do
            source 'public_key.erb'
            owner u['id']
            group u['gid'] || u['id']
            mode '0400'
            variables public_key: key_val
          end
        end
      end

      if u['ssh']['config']
        template "#{home_dir}/.ssh/config" do
          source 'config.erb'
          owner u['id']
          group u['gid'] || u['id']
          mode 0644
          variables(
              config: u['ssh']['config']
          )
        end
        execute 'mkdir -p /root/.ssh' do
          command 'mkdir -p /root/.ssh'
          user 'root'
          not_if { File.exist?('/root/.ssh') }
        end
        template '/root/.ssh/config' do
          source 'config.erb'
          owner 'root'
          group 'root'
          mode 0644
          variables(
              config: u['ssh']['config']
          )
        end
      end
    end
  else
    Chef::Log.debug("Not managing home files for #{u['username']}")
  end

  # add user to the specified groups
  u['groups'].each do |grp|
    group grp do
      members u['username']
      append true
      action :manage
    end
  end

  # configure user sudo access
  if u['sudo'].nil?
    sudo u['username'] do
      action :remove
    end
  else
    sudo u['username'] do
      user u['username']
      host u['sudo']['host']
      runas u['sudo']['runas']
      nopasswd u['sudo']['nopasswd']
      commands u['sudo']['commands']
      defaults u['sudo']['defaults']
      action :install
    end
  end
end
