# chef-workstation entry in /etc/hosts
hostsfile_entry 'node[:ipaddress]' do
  hostname 'chef-workstation'
  action :append
end
