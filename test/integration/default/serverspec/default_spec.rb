require 'spec_helper'

describe 'cookbook-opengrok::default' do

  context command('printenv JAVA_HOME') do
    its(:exit_status) { should eq 0 }
  end

  describe user('opengrok') do
    it { should exist }
  end

  describe group('opengrok') do
    it { should exist }
  end

  describe file('/opt/tomcat_opengrok/LICENSE') do
    it { should be_file }
    it { should be_owned_by 'opengrok' }
    it { should be_grouped_into 'opengrok' }
  end

  describe service('tomcat_opengrok') do
    it { should be_enabled }
    it { should be_running }
  end

  context file('/opt/opengrok/bin/OpenGrok') do
    it { should be_file }
    it { should be_owned_by 'opengrok' }
    it { should be_grouped_into 'opengrok' }
  end

  context file('/opt/tomcat_opengrok/webapps/source.war') do
    it { should be_file }
    it { should be_owned_by 'opengrok' }
  end

  context file('/var/opengrok/src') do
    it { pending; should be_directory }
    it { pending; should be_owned_by 'opengrok' }
  end

  context file('/var/opengrok/etc/configuration.xml') do
    it { pending; should be_file }
    it { pending; should be_owned_by 'opengrok' }
  end

  context command('git --version') do
    its(:exit_status) { pending; should eq 0}
  end
end
