include_recipe 'java'

opengrok_install 'my_opengrok' do
  download_url 'https://github.com/OpenGrok/OpenGrok/files/213268/opengrok-0.12.1.5.tar.gz'
  download_checksum 'c3ce079f6ed1526c475cb4b9a7aa901f75507318c93b436d6c14eba4098e4ead'
  tomcat_version '8.0.37'
  tomcat_tarball_uri 'http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.37/bin/apache-tomcat-8.0.37.tar.gz'
  install_path '/opt/custom'
  home_path '/var/custom/opengrok'
  version '100'
  opengrok_user 'custom_user'
  opengrok_group 'custom_group'
end

opengrok_index 'my_opengrok' do
  java_opts '-Xmx4096m'
  extra_opts '-P -H'
end
