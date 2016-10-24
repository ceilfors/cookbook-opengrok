include_recipe 'java'
include_recipe 'daun'
package 'git'

home_path = '/var/opengrok/'

opengrok_install 'opengrok' do
  download_url 'https://github.com/OpenGrok/OpenGrok/files/213268/opengrok-0.12.1.5.tar.gz'
  download_checksum 'c3ce079f6ed1526c475cb4b9a7aa901f75507318c93b436d6c14eba4098e4ead'
  home_path home_path
  version '0.12.1.5'
end

# Checkout daun repository so that git branches and tags are indexed too.
# See daun project for more details: https://github.com/ceilfors/daun
daun "#{home_path}/src/gq" do
  repository 'https://github.com/ceilfors/gq.git'
end

git "#{home_path}/src/daun" do
  repository 'https://github.com/ceilfors/daun.git'
  revision 'master'
end

opengrok_index 'opengrok'
