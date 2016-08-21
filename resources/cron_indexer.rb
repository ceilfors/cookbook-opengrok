property :home_path, String, name_property: true
property :opengrok_user, String
property :opengrok_group, String
property :install_path, String, default: '/opt/opengrok'
property :java_opts, String, default: '-Xmx2048m'
property :extra_opts, String, default: '-S -P -H'
property :cron_minute, String, default: '0'
property :cron_hour, String, default: '0'

default_action :create

action :create do

  indexer_path = ::File.join(home_path, 'index.sh')
  template indexer_path do
    source 'index.sh.erb'
    cookbook 'opengrok'
    owner opengrok_user
    group opengrok_group
    variables ({
      java_opts: java_opts,
      extra_opts: extra_opts,
      logging_properties_path: ::File.join(home_path, 'logging.properties'),
      opengrok_jar_path: ::File.join(install_path, 'opengrok', 'lib', 'opengrok.jar'),
      opengrok_configuration_path: ::File.join(home_path, 'etc', 'configuration.xml')
    })
  end

  cron 'opengrok cron indexer' do
    user opengrok_user
    command indexer_path
    minute cron_minute
    hour cron_hour
  end
end