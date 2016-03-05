node['dev']['pip'].each do |pkg|
    execute "pip install #{pkg}" do
        command "pip install #{pkg}"
    end
end
