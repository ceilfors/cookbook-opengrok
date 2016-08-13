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
  notifies :run, 'execute[deploy war]'
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

execute 'deploy war' do
  command 'cp -p /opt/opengrok/lib/source.war /opt/tomcat_opengrok/webapps'
  action :nothing
end

%w(src data etc log).each do |dir|
  directory File.join(node['opengrok']['home'], dir) do
    owner node['opengrok']['user']
    group node['opengrok']['group']
    recursive true
  end
end

# TODO: Need to configure OpenGrok web.xml to point to this file when we configure web.xml
template File.join(node['opengrok']['home'], 'etc/configuration.xml') do
  source 'configuration.xml.erb'
  owner node['opengrok']['user']
  group node['opengrok']['group']
  variables({
    data_root: File.join(node['opengrok']['home'], 'data'),
    src_root: File.join(node['opengrok']['home'], 'src')
  })
end

# TODO: Who is pointing to this logging.properties file?
template File.join(node['opengrok']['home'], 'logging.properties') do
  source 'logging.properties.erb'
  owner node['opengrok']['user']
  group node['opengrok']['group']
end