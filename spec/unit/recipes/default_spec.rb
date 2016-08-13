#
# Cookbook Name:: cookbook-opengrok
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'opengrok::default' do
  context 'When all attributes are default, on centos' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.2.1511') do |node|
        node.set['opengrok']['home'] = '/opengrok/home'
        node.set['opengrok']['index']['extra_opts'] = '-blah'
        node.set['opengrok']['index']['java_opts'] = '-Xmx1024m'
      end
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs ctags' do
      expect(chef_run).to install_package('ctags')
    end

    it 'should include java recipe' do
      expect(chef_run).to include_recipe('java')
    end

    it 'should create opengrok user' do
      expect(chef_run).to create_user(chef_run.node['opengrok']['user'])
    end

    it 'should create opengrok group' do
      expect(chef_run).to create_user(chef_run.node['opengrok']['group'])
    end

    it 'creates configuration.xml file' do
      file = '/opengrok/home/etc/configuration.xml'
      expect(chef_run).to create_template(file)
      template = chef_run.template(file)
      expect(template.variables[:data_root]).to eq('/opengrok/home/data')
      expect(template.variables[:src_root]).to eq('/opengrok/home/src')
    end

    it 'creates logging.properties file' do
      expect(chef_run).to create_template('/opengrok/home/logging.properties')
    end

    it 'creates index.sh file' do
      pending('implementation')
      file = '/opengrok/home/index.sh'
      expect(chef_run).to create_template(file)
      expect(chef_run).to render_file(file).with_content(%r(-R /opengrok/home/etc/configuration.xml))
      expect(chef_run).to render_file(file).with_content(%r(-Xmx1024m))
      expect(chef_run).to render_file(file).with_content(%r(-blah))
    end
  end
end
