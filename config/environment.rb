require 'bundler'
require 'pry'
require 'faker'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_relative "../lib/cli_menu.rb"
require_all 'app'
