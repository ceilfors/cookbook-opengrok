name 'opengrok'
maintainer 'Wisen Tanasa'
maintainer_email 'wisen@ceilfors.com'
license 'Apache 2.0'
description 'Installs/Configures OpenGrok'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'
issues_url 'https://github.com/ceilfors/cookbook-opengrok/issues'
source_url 'https://github.com/ceilfors/cookbook-opengrok'

%w(ubuntu centos redhat suse opensuse opensuseleap).each do |os|
  supports os
end

depends 'ark', '~> 1.2.0'
depends 'tomcat', '~> 2.3.1'

chef_version '>= 12.5'