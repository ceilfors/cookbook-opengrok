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

end