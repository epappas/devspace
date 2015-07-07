# include_recipe 'mysql'

mysql_service 'mysql_db' do
    port '3306'
    version '5.5'
    initial_root_password 'root'
    action [:create, :start]
end