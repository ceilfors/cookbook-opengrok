#
# Cookbook Name:: cookbook-opengrok
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

group node['opengrok']['group']
user node['opengrok']['user'] do
  group node['opengrok']['group']
  system true
  shell '/bin/nologin'
end

ark 'opengrok' do
  url node['opengrok']['download_url']
  checksum node['opengrok']['checksum']
  prefix_root '/opt'
  prefix_home '/opt'
  prefix_bin  '/opt/bin'
  version node['opengrok']['version']
  owner node['opengrok']['user']
  group node['opengrok']['group']
end

include_recipe 'java'

package 'ctags' do
  action :install
end

tomcat_install 'opengrok' do
  tarball_uri 'http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.36/bin/apache-tomcat-8.0.36.tar.gz'
  tomcat_user node['opengrok']['user']
  tomcat_group node['opengrok']['group']
end

tomcat_service 'opengrok' do
  action [:start, :enable]
  tomcat_user node['opengrok']['user']
  tomcat_group node['opengrok']['group']
end

execute 'deploy opengrok' do
  command '/opt/opengrok/bin/OpenGrok deploy'
  environment OPENGROK_TOMCAT_BASE: '/opt/tomcat_opengrok'
end