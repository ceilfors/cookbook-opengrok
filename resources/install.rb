property :download_url, String
property :download_checksum, String
property :install_path, String
property :version, String
property :user, String
property :group, String

default_action :install

action :install do

  include_recipe 'java'

  group new_resource.group
  user new_resource.user do
    group new_resource.group
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
    owner new_resource.user
    group new_resource.group
    notifies :run, 'execute[deploy opengrok war]'
  end

  package 'ctags' do
    action :install
  end

  tomcat_install 'opengrok' do
    tarball_uri 'http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.36/bin/apache-tomcat-8.0.36.tar.gz'
    install_path ::File.join(new_resource.install_path, 'tomcat_opengrok')
    tomcat_user new_resource.user
    tomcat_group new_resource.group
  end

  tomcat_service 'opengrok' do
    action [:start, :enable]
    install_path ::File.join(new_resource.install_path, 'tomcat_opengrok')
    tomcat_user new_resource.user
    tomcat_group new_resource.group
  end

  copy_source = ::File.join(install_path, 'opengrok', 'lib', 'source.war')
  copy_target = ::File.join(install_path, 'tomcat_opengrok', 'webapps')

  execute 'deploy opengrok war' do
    command "cp -p #{copy_source} #{copy_target}"
    action :nothing
  end
end


