property :download_url, String
property :download_checksum, String
property :install_path, String
property :version, String
property :opengrok_user, String
property :opengrok_group, String

default_action :install

action :install do

  include_recipe 'java'

  group opengrok_group
  user opengrok_user do
    group opengrok_group
    system true
    shell '/bin/nologin'
  end

  ark 'opengrok' do
    url download_url
    checksum node['opengrok']['checksum']
    prefix_root install_path
    prefix_home install_path
    prefix_bin ::File.join(install_path, 'bin')
    version new_resource.version
    owner opengrok_user
    group opengrok_group
    notifies :run, 'execute[deploy opengrok war]'
  end

  package 'ctags' do
    action :install
  end

  tomcat_install 'opengrok' do
    tarball_uri 'http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.36/bin/apache-tomcat-8.0.36.tar.gz'
    tomcat_user opengrok_user
    tomcat_group opengrok_group
  end

  tomcat_service 'opengrok' do
    action [:start, :enable]
    tomcat_user opengrok_user
    tomcat_group opengrok_group
  end

  copy_source = ::File.join(install_path, 'opengrok', 'lib', 'source.war')
  copy_target = ::File.join(install_path, 'tomcat_opengrok', 'webapps')

  execute 'deploy opengrok war' do
    command "cp -p #{copy_source} #{copy_target}"
    action :nothing
  end
end


