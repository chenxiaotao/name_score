ENV["LANG"]="en_US.UTF-8"

require 'bundler/setup'

require 'active_support'
require 'active_support/core_ext'
require 'colorize'
require 'mechanize'

def run
  page = agent.get("http://life.httpcn.com/xingming.asp")
  form = page.form_with(name: 'theform')
  form.xing = '陈'
  form.ming = '姝言'
  form.radiobutton(name: 'data_type').check
  form.year = '2017'
  form.month = '8'
  form.day   = '22'
  form.hour  = '16'
  form.minute = '10'
  form.pid    = '四川'
  form.cid    = '成都'
  form.sex    = '0'
  form.radiobutton(name: 'wxxy').check
  result = form.submit
  p result.search("div.chaxun_b").search('font').search('b').first.text
  p result.search("div.chaxun_b").search('font').search('b').last.text
end

def agent
  @client = Mechanize.new
end

run
