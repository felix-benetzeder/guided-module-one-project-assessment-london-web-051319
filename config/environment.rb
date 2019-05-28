require 'bundler'
require 'pry'
require 'faker'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_relative '../lib/cli_run.rb'
require_all 'app'
