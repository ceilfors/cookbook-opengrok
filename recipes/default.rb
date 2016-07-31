#
# Cookbook Name:: cookbook-opengrok
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
include_recipe 'java'

package 'ctags' do
  action :install
end

tomcat_install 'opengrok' do
  tarball_uri 'http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.36/bin/apache-tomcat-8.0.36.tar.gz'
  tomcat_user 'opengrok'
  tomcat_group 'opengrok'
end

tomcat_service 'opengrok' do
  action [:start, :enable]
  tomcat_user 'opengrok'
  tomcat_group 'opengrok'
end
