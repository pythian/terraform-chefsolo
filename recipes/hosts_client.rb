hostsfile_entry '${chef-client-addr}' do
  hostname 'chef-workstation'
  action :append
end
