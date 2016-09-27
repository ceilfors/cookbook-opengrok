property :download_url, String
property :download_checksum, String
property :tomcat_version, String, default: '8.0.36'
property :tomcat_tarball_uri, String, default: 'http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.36/bin/apache-tomcat-8.0.36.tar.gz'
property :install_path, String, default: '/opt/'
property :home_path, String, default: '/var/opengrok'
property :version, String
property :opengrok_user, String, default: 'opengrok'
property :opengrok_group, String, default: 'opengrok'

default_action :install

action :install do
  ctags_package_name = value_for_platform_family(
    'debian' => 'exuberant-ctags',
    'default' => 'ctags'
  )
  package ctags_package_name do
    action :install
  end

  group opengrok_group
  user opengrok_user do
    group opengrok_group
    system true
  end

  ark 'opengrok' do
    url download_url
    checksum download_checksum
    prefix_root install_path
    prefix_home install_path
    prefix_bin ::File.join(install_path, 'bin')
    version new_resource.version
    owner opengrok_user
    group opengrok_group
    notifies :run, 'execute[deploy_opengrok_war]'
  end

  directory home_path do
    owner opengrok_user
    group opengrok_group
    recursive true
  end

  %w(src data etc log).each do |dir|
    directory ::File.join(home_path, dir) do
      owner opengrok_user
      group opengrok_group
    end
  end

  context_xml_path = ::File.join('/opt/tomcat_opengrok', 'conf', 'context.xml')
  configuration_xml_path = ::File.join(home_path, 'etc', 'configuration.xml')
  template configuration_xml_path do
    source 'configuration.xml.erb'
    cookbook 'opengrok'
    owner opengrok_user
    group opengrok_group
    variables data_root: ::File.join(home_path, 'data'),
              src_root: ::File.join(home_path, 'src'),
              ctags: value_for_platform_family(
                %w(suse debian) => '/usr/bin/ctags',
                'default' => '/bin/ctags'
              )
    notifies :create, template: context_xml_path
    notifies :restart, tomcat_service: 'opengrok'
  end

  # TODO: Tomcat symlink is hardcoded in tomcat cookbook, remove when chef-cookbooks/tomcat#269
  tomcat_install 'opengrok' do
    version tomcat_version
    tarball_uri tomcat_tarball_uri
    tomcat_user opengrok_user
    tomcat_group opengrok_group
    notifies :create, "template[#{context_xml_path}]", :immediately
    notifies :run, 'execute[deploy_opengrok_war]'
  end

  template context_xml_path do
    source 'context.xml.erb'
    cookbook 'opengrok'
    owner opengrok_user
    group opengrok_group
    variables opengrok_configuration_path: configuration_xml_path
    notifies :restart, tomcat_service: 'opengrok'
  end

  copy_source = ::File.join(install_path, 'opengrok', 'lib', 'source.war')
  # TODO: Tomcat symlink is hardcoded in tomcat cookbook, remove when chef-cookbooks/tomcat#269
  webapps_dir = ::File.join('/opt/tomcat_opengrok', 'webapps')
  webapp_dir = ::File.join(webapps_dir, 'source')

  directory webapp_dir do
    owner opengrok_user
    group opengrok_group
  end

  execute 'deploy_opengrok_war' do
    command "cp -p #{copy_source} #{webapps_dir}"
    action :nothing
    notifies :stop, 'tomcat_service[opengrok]', :before
    notifies :run, 'execute[delete_webapp]', :before
    notifies :run, 'execute[extract_war]', :immediately
    notifies :start, 'tomcat_service[opengrok]', :delayed
  end

  execute 'delete_webapp' do
    command "rm -rf #{::File.join(webapp_dir, '*')}"
    action :nothing
  end

  execute 'extract_war' do
    command "jar xf #{::File.join(webapps_dir, 'source.war')}"
    cwd webapp_dir
    user opengrok_user
    group opengrok_group
    action :nothing
  end

  tomcat_service 'opengrok' do
    action [:start, :enable]
    tomcat_user opengrok_user
    tomcat_group opengrok_group
  end
end
