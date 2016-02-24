hostsfile_entry '${chef-client-addr}' do
  hostname 'chef-client'
  action :update
end
