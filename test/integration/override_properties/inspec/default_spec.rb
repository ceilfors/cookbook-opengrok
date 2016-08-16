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
