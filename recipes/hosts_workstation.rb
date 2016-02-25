# chef-client entry in /etc/hosts
hostsfile_entry '${chef-client-addr}' do
  hostname 'chef-client'
  action :append
end
