#
# Cookbook Name:: cookbook-opengrok
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'java'

opengrok_install 'opengrok' do
  download_url node['opengrok']['download_url']
  download_checksum node['opengrok']['checksum']
  install_path '/opt'
  home_path node['opengrok']['home']
  version node['opengrok']['version']
  opengrok_user node['opengrok']['user']
  opengrok_group node['opengrok']['group']
end

opengrok_cron_indexer 'opengrok'