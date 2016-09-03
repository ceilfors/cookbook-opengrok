require 'spec_helper'

describe 'opengrok helloworld' do

  describe command('printenv JAVA_HOME') do
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
    it { should be_grouped_into 'opengrok' }
    it { should be_owned_by 'opengrok' }
  end

  describe file('/opt/tomcat_opengrok/conf/context.xml') do
    its(:content) { should match '<Parameter name="CONFIGURATION" value="/var/opengrok/etc/configuration.xml" override="false"' }
  end

  describe service('tomcat_opengrok') do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/opt/opengrok/bin/OpenGrok') do
    it { should be_file }
    it { should be_grouped_into 'opengrok' }
    it { should be_owned_by 'opengrok' }
  end

  describe file('/opt/tomcat_opengrok/webapps/source.war') do
    it { should be_file }
    it { should be_owned_by 'opengrok' }
  end

  %w(src data etc log).each do |dir|
    describe file("/var/opengrok/#{dir}") do
      it { should be_directory }
      it { should be_owned_by 'opengrok' }
    end
  end

  describe file('/var/opengrok/etc/configuration.xml') do
    it { should be_file }
    it { should be_owned_by 'opengrok' }
    its(:content) {
      should match %r(<void property="dataRoot">\n[ ]+<string>/var/opengrok/data</string>)
      should match %r(<void property="sourceRoot">\n[ ]+<string>/var/opengrok/src</string>)
    }
  end

  describe file('/var/opengrok/logging.properties') do
    it { should be_file }
    it { should be_owned_by 'opengrok' }
    its(:content) { should match %r(FileHandler\.pattern = /var/opengrok/log/.*) }
  end

  describe file('/var/opengrok/index.sh') do
    it { should be_file }
    it { should be_grouped_into 'opengrok' }
    it { should be_owned_by 'opengrok' }
    it { should be_executable }
    its(:content) do
      # TODO It seems like ServerSpec output is not showing nicely when we have multiple 'should match'
      # The output shows as if we only have 1 test case which make it not really clear for the user.
      should match /-Xmx2048m/
      should match %r(-Djava.util.logging.config.file=/var/opengrok/logging.properties)
      should match %r(-jar /opt/opengrok/lib/opengrok.jar)
      should match %r(-R /var/opengrok/etc/configuration.xml)
      should match /-S -P -H/
    end
  end

  describe port(2424) do
    it { should be_listening }
  end

  describe port(8080) do
    it { should be_listening }
  end

  describe file('/var/opengrok/data/index') do
    it { should be_directory }
    it { should be_owned_by 'opengrok' }
  end

  describe command('curl http://localhost:8080/source/') do
    its(:stdout) { should match %r(<title>Search</title>) }
    its(:stdout) { should match %r(<option value="gq">gq</option>) }
    its(:stdout) { should match %r(<option value="daun">daun</option>) }
  end
end
