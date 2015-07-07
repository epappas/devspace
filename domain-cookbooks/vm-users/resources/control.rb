#
# Cookbook Name:: vm-users
# Resources:: control
#

actions :create, :remove

state_attrs :cookbook,
            :data_bag,
            :search_user,
            :default_shell

# :data_bag is the object to search
# :search_user is the user name to search for, defaults to resource name
# :default_shell is the default shell to be used, in case if user shell not specified
# :cookbook is the name of the cookbook that the authorized_keys template should be found in
attribute :data_bag, :kind_of => String, :default => "users"
attribute :search_user, :kind_of => String, :name_attribute => true
attribute :default_shell, :kind_of => String
attribute :cookbook, :kind_of => String, :default => "vm-users"
attribute :manage_nfs_home_dirs, :kind_of => [TrueClass, FalseClass], :default => true

def initialize(*args)
  super
  @action = :create
end
