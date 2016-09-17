require 'spec_helper'

describe 'non default properties' do
  describe command('printenv JAVA_HOME') do
    its(:exit_status) { should eq 0 }
  end

  it_behaves_like 'opengrok install',
                  install_path: '/opt/custom',
                  home_path: '/var/custom/opengrok',
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
