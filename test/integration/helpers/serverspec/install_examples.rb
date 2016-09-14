require_relative 'spec_helper'

shared_examples_for 'opengrok install' do |args = {}|
  expected_install_path = args[:install_path] || '/opt'
  expected_home_path = args[:home_path] || '/var/opengrok'
  expected_user = args[:user] || 'opengrok'
  expected_group = args[:group] || 'opengrok'

  describe user(expected_user) do
    it { should exist }
  end

  describe group(expected_group) do
    it { should exist }
  end

  describe file('/opt/tomcat_opengrok/LICENSE') do
    it { should be_file }
    it { should be_grouped_into expected_group }
    it { should be_owned_by expected_user }
  end

  describe file('/opt/tomcat_opengrok/conf/context.xml') do
    its(:content) { should match '<Parameter name="CONFIGURATION" value="/var/opengrok/etc/configuration.xml" override="false"' }
  end

  describe service('tomcat_opengrok') do
    it { should be_enabled }
    it { should be_running }
  end

  describe file("#{expected_install_path}/opengrok/bin/OpenGrok") do
    it { should be_file }
    it { should be_grouped_into expected_group }
    it { should be_owned_by expected_user }
  end

  describe file('/opt/tomcat_opengrok/webapps/source.war') do
    it { should be_file }
    it { should be_owned_by expected_user }
  end

  %w(src data etc log).each do |dir|
    describe file("#{expected_home_path}/#{dir}") do
      it { should be_directory }
      it { should be_owned_by expected_user }
    end
  end

  describe file("#{expected_home_path}/etc/configuration.xml") do
    it { should be_file }
    it { should be_owned_by expected_user }
    its(:content) {
      should match %r(<void property="dataRoot">\n[ ]+<string>#{expected_home_path}/data</string>)
      should match %r(<void property="sourceRoot">\n[ ]+<string>#{expected_home_path}/src</string>)
    }
  end

  describe port(2424) do
    it { should be_listening }
  end

  describe port(8080) do
    it { should be_listening }
  end

  describe command('curl http://localhost:8080/source/') do
    its(:stdout) { should match %r(<title>Search</title>) }
  end
end
