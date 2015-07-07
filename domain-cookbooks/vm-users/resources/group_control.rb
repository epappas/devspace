#
# Cookbook Name:: vm-users
# Resources:: control
# Author:: Alexandr Donciu (<adonciu@tacitknowledge.com>)
#

actions :create, :remove

state_attrs :data_bag,
            :search_group

# :data_bag is the object to search
# :search_group is the group name to search for, defaults to resource name
attribute :data_bag, :kind_of => String, :default => "groups"
attribute :search_group, :kind_of => String, :name_attribute => true

def initialize(*args)
  super
  @action = :create
end
