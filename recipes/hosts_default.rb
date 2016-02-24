# chef-client entry in /etc/hosts
hostsfile_entry '${chef-client-addr}' do
  hostname 'chef-client'
  action :append
end

#chef-workstation entry in /etc/hosts
hostsfile_entry '${chef-workstation-addr}' do
  hostname 'chef-workstation'
  action :append
end
