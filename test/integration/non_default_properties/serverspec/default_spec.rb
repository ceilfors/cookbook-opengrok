require 'spec_helper'

describe 'non default properties' do
  it_behaves_like 'opengrok install',
                  install_path: '/opt/custom',
                  home_path: '/var/custom/opengrok',
                  tomcat_version: '8.0.37',
                  user: 'custom_user',
                  group: 'custom_group'

  it_behaves_like 'opengrok index',
                  install_path: '/opt/custom',
                  home_path: '/var/custom/opengrok',
                  user: 'custom_user',
                  group: 'custom_group',
                  java_opts: '-Xmx4096m',
                  extra_opts: '-P -H'
end
