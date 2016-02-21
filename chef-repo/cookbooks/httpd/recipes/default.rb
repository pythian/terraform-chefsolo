#
# Cookbook Name:: chef-solo-server
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

httpd_service 'default' do
  action :create
end

httpd_module 'ssl' do
  action :create

httpd_service 'default' do
  action :start
end
