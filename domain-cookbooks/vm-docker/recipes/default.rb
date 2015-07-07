docker_service 'default' do
  action [:create, :start]
end

registry = node['docker']['registry']

if registry
  docker_registry registry['url'] do
    username registry['username']
    password registry['password']
  end
end

images = node['docker']['images']

if images
  images.each do |img|
    docker_image img['name'] do
      action :pull
    end
  end
end

containers = node['docker']['containers']

if containers
  containers.each do |c|
    docker_container c['name'] do
      image c['image']
      port c['port']
      command c['command']
      detach true
      init_type false
    end
  end
end
