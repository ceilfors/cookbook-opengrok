#
# Cookbook Name:: cookbook-opengrok
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'opengrok_test::chefspec' do
  context 'When all attributes are default, on centos' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.2.1511',
                                          step_into: %w(opengrok_install opengrok_index))
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs ctags' do
      expect(chef_run).to install_package('ctags')
    end

    it 'should create opengrok user' do
      expect(chef_run).to create_user('opengrok')
    end

    it 'should create opengrok group' do
      expect(chef_run).to create_user('opengrok')
    end

    it 'creates configuration.xml file' do
      file = '/var/opengrok/etc/configuration.xml'
      expect(chef_run).to create_template(file)
      template = chef_run.template(file)
      expect(template.variables[:data_root]).to eq('/var/opengrok/data')
      expect(template.variables[:src_root]).to eq('/var/opengrok/src')
    end

    it 'creates logging.properties file' do
      expect(chef_run).to create_template('/var/opengrok/logging.properties')
    end

    it 'creates index.sh file' do
      expect(chef_run).to create_template('/var/opengrok/index.sh')
    end
  end
end
