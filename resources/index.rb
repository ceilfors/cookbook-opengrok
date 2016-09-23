property :instance_name, String, name_property: true
property :java_opts, String, default: '-Xmx2048m'
property :extra_opts, String, default: '-S -P -H'

default_action :update

action :update do
  opengrok_install = resources(opengrok_install: instance_name)
  home_path = opengrok_install.home_path
  install_path = opengrok_install.install_path
  opengrok_user = opengrok_install.opengrok_user
  opengrok_group = opengrok_install.opengrok_group

  indexer_path = ::File.join(home_path, 'index.sh')
  logging_properties_path = ::File.join(home_path, 'logging.properties')

  template logging_properties_path do
    source 'logging.properties.erb'
    cookbook 'opengrok'
    owner opengrok_user
    group opengrok_group
    variables logging_pattern: ::File.join(home_path, 'log', 'opengrok%g.%u.log')
  end

  template indexer_path do
    source 'index.sh.erb'
    cookbook 'opengrok'
    owner opengrok_user
    group opengrok_group
    variables java_opts: java_opts,
              extra_opts: extra_opts,
              logging_properties_path: logging_properties_path,
              opengrok_jar_path: ::File.join(install_path, 'opengrok', 'lib', 'opengrok.jar'),
              opengrok_configuration_path: ::File.join(home_path, 'etc', 'configuration.xml')
    mode '0775'
  end

  # TODO: Log rotate
  bash 'index_opengrok' do
    user opengrok_user
    cwd home_path
    code "set -o pipefail; #{indexer_path} 2>&1 | tee --append #{::File.join(home_path, 'log', 'index.log')}"
  end
end
