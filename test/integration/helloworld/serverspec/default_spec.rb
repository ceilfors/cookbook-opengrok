require 'spec_helper'

describe 'opengrok helloworld' do

  describe command('printenv JAVA_HOME') do
    its(:exit_status) { should eq 0 }
  end

  it_behaves_like 'opengrok install'

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

  describe file('/var/opengrok/data/index') do
    it { should be_directory }
    it { should be_owned_by 'opengrok' }
  end

  describe command('curl http://localhost:8080/source/') do
    its(:stdout) { should match %r(<option value="gq">gq</option>) }
    its(:stdout) { should match %r(<option value="daun">daun</option>) }
  end
end
