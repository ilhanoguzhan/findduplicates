require 'rack'
require 'rack/server'
require 'thin'

require_relative 'app'

run App.new