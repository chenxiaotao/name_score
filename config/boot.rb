ENV["LANG"]="en_US.UTF-8"

require 'bundler/setup'

require 'active_support'
require 'active_support/core_ext'
require 'colorize'
require 'mechanize'

require_relative '../lib/console'
require_relative '../lib/user_config'
require_relative '../lib/word_libary'
require_relative '../lib/name_score'


ROOT_PATH = File.expand_path('../', File.dirname(__FILE__))

# 请求的表单地址
REQUEST_URL = "http://life.httpcn.com/xingming.asp"
LOG_PATH = "#{ROOT_PATH}/log/"
