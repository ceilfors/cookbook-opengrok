#
# Cookbook Name:: cookbook-opengrok
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

opengrok_install 'opengrok' do
  download_url node['opengrok']['download_url']
  download_checksum node['opengrok']['checksum']
  install_path '/opt'
  version node['opengrok']['version']
  opengrok_user node['opengrok']['user']
  opengrok_group node['opengrok']['group']
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

template File.join(node['opengrok']['home'], 'index.sh') do
  source 'index.sh.erb'
  owner node['opengrok']['user']
  group node['opengrok']['group']
end
