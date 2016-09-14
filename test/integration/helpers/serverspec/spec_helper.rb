require 'serverspec'

if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM).nil?
  set :backend, :exec
else
  set :backend, :cmd
  set :os, family: 'windows'
end

base_path = File.dirname(__FILE__)
Dir["#{base_path}/*_examples.rb"].each do |ex|
  require_relative ex
end
