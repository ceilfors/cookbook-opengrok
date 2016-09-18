require 'spec_helper'

describe 'opengrok helloworld' do
  it_behaves_like 'opengrok install'
  it_behaves_like 'opengrok index', projects: %w(gq daun)
end
