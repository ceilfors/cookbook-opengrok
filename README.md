# OpenGrok cookbook

[![Build Status](https://travis-ci.org/ceilfors/cookbook-opengrok.svg?branch=master)](https://travis-ci.org/ceilfors/cookbook-opengrok)
[![Cookbook Version](https://img.shields.io/cookbook/v/opengrok.svg)](https://supermarket.chef.io/cookbooks/opengrok)

A chef library cookbook that provides resources for installing and indexing OpenGrok.

## Requirements

### Platforms

- Debian / Ubuntu derivatives
- RHEL and derivatives
- openSUSE / SUSE Linux Enterprises

### Chef

- Chef 12.5+

## Usage

1. Take a look into the [`helloworld recipe`](test/fixtures/cookbooks/opengrok_test/recipes/helloworld.rb).
2. Adapt the `helloworld recipe` to your own cookbook wrapper, especially the generation of the `src` directory.

    You can use any chef resources from any community cookbooks to populate that `src` directory as long as its supported by OpenGrok, e.g. git resource, subversion resource, etc. 

3. Schedule `chef-client` as a cron job. This will be the point where your `src` is being updated periodically and indexed by Chef

    You can use the [chef-client::cron](https://github.com/chef-cookbooks/chef-client#cron) recipe.

## Resources

### opengrok_install

opengrok_install installs an instance of opengrok and all of its required dependencies
and files. This resource will also install tomcat and enable it as a service for you.

#### properties

- `download_url`: The opengrok download URL
- `download_checksum`: The SHA-256 checksum of the opengrok binary
- `tomcat_version`: The version of tomcat to be installed. Default: 8.0.36
- `tomcat_tarball_uri`: The full path to download tomcat. Default: http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.36/bin/apache-tomcat-8.0.36.tar.gz
- `install_path`: The full path to install opengrok. With the default value, the installation will go to /opt/opengrok. Default: /opt
- `home_path`: The full path to opengrok home directory. This will be the location where the src directory, data directory, and configuration.xml is found. Default: /var/opengrok
- `version`: The version of opengrok to be installed. Currently only used for directory name generation.
- `opengrok_user`: The system user who will manage opengrok files and service. Default: 'opengrok'
- `opengrok_group`: The group which will own opengrok files. Default: 'opengrok'

#### actions

- `install` (default)

### opengrok_index

opengrok_index will trigger OpenGrok indexing process. You can only use opengrok_index when you have declared opengrok_install.

#### properties

- `java_opts`: The Java options that will be used for the OpenGrok indexing jar. Default: -Xmx2048m
- `extra_opts`: The options that will be passed on to OpenGrok indexing jar. Default: -S -P -H

#### actions

- `update` (default)

# Copyright

```text
Copyright 2016 Wisen Tanasa

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
