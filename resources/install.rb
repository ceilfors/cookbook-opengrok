property :download_url, String
property :download_checksum, String
property :install_path, String
property :home_path, String
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

  %w(src data etc log).each do |dir|
    directory ::File.join(home_path, dir) do
      owner opengrok_user
      group opengrok_group
      recursive true
    end
  end

# TODO: Need to configure OpenGrok web.xml to point to this file when we configure web.xml
  template ::File.join(home_path, 'etc', 'configuration.xml') do
    source 'configuration.xml.erb'
    cookbook 'opengrok'
    owner opengrok_user
    group opengrok_group
    variables ({
      data_root: ::File.join(home_path, 'data'),
      src_root: ::File.join(home_path, 'src')
    })
  end

  template ::File.join(home_path, 'logging.properties') do
    source 'logging.properties.erb'
    cookbook 'opengrok'
    owner opengrok_user
    group opengrok_group
    variables ({
      logging_pattern: ::File.join(home_path, 'log', 'opengrok%g.%u.log')
    })
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
  # Tomcat symlink is hardcoded in tomcat cookbook
  copy_target = ::File.join('/opt/tomcat_opengrok', 'webapps')

  execute 'deploy opengrok war' do
    command "cp -p #{copy_source} #{copy_target}"
    action :nothing
  end
end
