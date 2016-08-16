opengrok_install 'opengrok' do
  download_url 'https://github.com/OpenGrok/OpenGrok/files/213268/opengrok-0.12.1.5.tar.gz'
  download_checksum 'c3ce079f6ed1526c475cb4b9a7aa901f75507318c93b436d6c14eba4098e4ead'
  install_path '/opt/custom'
  version '100'
  opengrok_user 'custom_user'
  opengrok_group 'custom_group'
end