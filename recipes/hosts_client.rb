hostsfile_entry '${chef-client-addr}' do
  hostname 'chef-client'
  action :append
end
