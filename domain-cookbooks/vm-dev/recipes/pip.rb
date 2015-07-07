node['dev']['pip'].each do |pkg|
    execute 'pip install #{pkg}' do
        command 'sudo pip install #{pkg}'
    end
end
