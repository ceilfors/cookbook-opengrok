include_recipe 'java'
package 'git'

home_path = '/var/opengrok/'

opengrok_install 'opengrok' do
  download_url 'https://github.com/OpenGrok/OpenGrok/files/213268/opengrok-0.12.1.5.tar.gz'
  download_checksum 'c3ce079f6ed1526c475cb4b9a7aa901f75507318c93b436d6c14eba4098e4ead'
  home_path home_path
  version '0.12.1.5'
end

git "#{home_path}/src/gq" do
  repository 'https://github.com/ceilfors/gq.git'
  revision 'master'
end

git "#{home_path}/src/daun" do
  repository 'https://github.com/ceilfors/daun.git'
  revision 'master'
end

opengrok_index 'opengrok'
