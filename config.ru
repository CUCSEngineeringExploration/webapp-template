require 'bundler'
Bundler.require
require "sinatra/reloader" rescue nil
require './app'
run Sinatra::Application
