require 'spec_helper'

describe 'opengrok overridden properties' do

  describe command('printenv JAVA_HOME') do
    its(:exit_status) { should eq 0 }
  end

  describe user('custom_user') do
    it { should exist }
  end

  describe group('custom_group') do
    it { should exist }
  end

  describe file('/opt/tomcat_opengrok/LICENSE') do
    it { should be_file }
    it { should be_owned_by 'custom_user' }
    it { should be_grouped_into 'custom_group' }
  end

  describe service('tomcat_opengrok') do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/opt/custom/opengrok/bin/OpenGrok') do
    it { should be_file }
    it { should be_owned_by 'custom_user' }
    it { should be_grouped_into 'custom_group' }
  end

  describe file('/opt/tomcat_opengrok/webapps/source.war') do
    it { should be_file }
    it { should be_owned_by 'custom_user' }
  end

  describe command('curl http://localhost:8080/source/') do
    its(:stdout) { should match %r(<title>Search</title>) }
  end

  %w(src data etc log).each do |dir|
    describe file("/var/custom/opengrok/#{dir}") do
      it { should be_directory }
      it { should be_owned_by 'custom_user' }
    end
  end

  describe file('/var/custom/opengrok/etc/configuration.xml') do
    it { should be_file }
    it { should be_owned_by 'custom_user' }
    its(:content) {
      should match %r(<void property="dataRoot">\n[ ]+<string>/var/custom/opengrok/data</string>)
      should match %r(<void property="sourceRoot">\n[ ]+<string>/var/custom/opengrok/src</string>)
    }
  end

  describe file('/var/custom/opengrok/logging.properties') do
    it { should be_file }
    it { should be_owned_by 'custom_user' }
    its(:content) { should match %r(FileHandler\.pattern = /var/custom/opengrok/log/.*) }
  end

  describe file('/var/custom/opengrok/index.sh') do
    it { should be_file }
    it { should be_owned_by 'custom_user' }
    it { should be_grouped_into 'custom_group' }
    it { should be_executable }
    its(:content) {
      should match /-Xmx4096m/
      should match %r(-Djava.util.logging.config.file=/var/custom/opengrok/logging.properties)
      should match %r(-jar /opt/custom/opengrok/lib/opengrok.jar)
      should match %r(-R /var/custom/opengrok/etc/configuration.xml)
      should match /-P -H/
    }
  end

  describe cron do
    it { should have_entry('10 10 * * * /var/custom/opengrok/index.sh').with_user('custom_user') }
  end

end