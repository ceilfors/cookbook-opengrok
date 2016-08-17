property :home_path, String, name_property: true
property :opengrok_user, String
property :opengrok_group, String

default_action :manage

action :manage do
  %w(src data etc log).each do |dir|
    directory ::File.join(home_path, dir) do
      owner opengrok_user
      group opengrok_group
      recursive true
    end
  end

# TODO: Need to configure OpenGrok web.xml to point to this file when we configure web.xml
  template ::File.join(home_path, 'etc/configuration.xml') do
    source 'configuration.xml.erb'
    owner opengrok_user
    group opengrok_group
    variables({
                data_root: ::File.join(home_path, 'data'),
                src_root: ::File.join(home_path, 'src')
              })
  end

# TODO: Who is pointing to this logging.properties file?
  template ::File.join(home_path, 'logging.properties') do
    source 'logging.properties.erb'
    owner opengrok_user
    group opengrok_group
  end

  template ::File.join(home_path, 'index.sh') do
    source 'index.sh.erb'
    owner opengrok_user
    group opengrok_group
  end
end
