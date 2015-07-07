remote_file '/tmp/avro-cpp-1.7.7.tar.gz' do
  source 'http://mirror.catn.com/pub/apache/avro/avro-1.7.7/cpp/avro-cpp-1.7.7.tar.gz'
  action :create_if_missing
end

# https://github.com/apache/avro/archive/release-1.7.7.zip

execute 'avro tar xzvf' do
  command 'tar xzvf /tmp/avro-cpp-1.7.7.tar.gz'
  cwd '/tmp'
  not_if { File.exist?('/usr/local/lib/libavrocpp.so.1.7.7.0') }
end

execute 'avro build install' do
  command 'sudo ./build.sh install'
  cwd '/tmp/avro-cpp-1.7.7'
  not_if { File.exist?('/usr/local/lib/libavrocpp.so.1.7.7.0') }
end

execute 'avro sym link' do
  command 'sudo ln -s /usr/local/lib/libavrocpp.so.1.7.7.0 /usr/lib/libavrocpp.so.1.7.7.0'
  cwd '/usr'
end
