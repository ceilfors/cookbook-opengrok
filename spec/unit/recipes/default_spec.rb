#
# Cookbook Name:: cookbook-opengrok
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'opengrok::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.2.1511')
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
  end
end
