require 'spec_helper'

describe 'opengrok helloworld' do
  describe command('printenv JAVA_HOME') do
    its(:exit_status) { should eq 0 }
  end

  it_behaves_like 'opengrok install'
  it_behaves_like 'opengrok index', projects: %w(gq daun)
end
