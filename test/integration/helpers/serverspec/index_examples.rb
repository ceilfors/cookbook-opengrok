require_relative 'spec_helper'

shared_examples_for 'opengrok index' do |args = {}|
  expected_install_path = args[:install_path] || '/opt'
  expected_home_path = args[:home_path] || '/var/opengrok'
  expected_user = args[:user] || 'opengrok'
  expected_group = args[:group] || 'opengrok'
  expected_projects = args[:projects] || []
  expected_java_opts = args[:java_opts] || '-Xmx2048m'
  expected_extra_opts = args[:extra_opts] || '-S -P -H'

  describe file("#{expected_home_path}/logging.properties") do
    it { should be_file }
    it { should be_owned_by expected_user }
    its(:content) { should match %r(FileHandler\.pattern = #{expected_home_path}/log/.*) }
  end

  describe file("#{expected_home_path}/index.sh") do
    it { should be_file }
    it { should be_grouped_into expected_group }
    it { should be_owned_by expected_user }
    it { should be_executable }
    its(:content) do
      # TODO It seems like ServerSpec output is not showing nicely when we have multiple 'should match'
      # The output shows as if we only have 1 test case which make it not really clear for the user.
      should match /#{expected_java_opts}/
      should match %r(-Djava.util.logging.config.file=#{expected_home_path}/logging.properties)
      should match %r(-jar #{expected_install_path}/opengrok/lib/opengrok.jar)
      should match %r(-R #{expected_home_path}/etc/configuration.xml)
      should match /#{expected_extra_opts}/
    end
  end

  describe file("#{expected_home_path}/data/index") do
    it { should be_directory }
    it { should be_owned_by expected_user }
  end

  expected_projects.each do |project|
    describe command('curl http://localhost:8080/source/') do
      its(:stdout) { should match %r(<option value="#{project}">#{project}</option>) }
    end
  end
end
