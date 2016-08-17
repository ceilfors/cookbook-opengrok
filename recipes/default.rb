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

opengrok_configuration node['opengrok']['home'] do
  opengrok_user node['opengrok']['user']
  opengrok_group node['opengrok']['group']
end
