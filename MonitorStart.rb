#!/usr/bin/env ruby
require 'optparse'
require_relative  'CouchbaseMonitor'

options = {}
opt_parser = OptionParser.new do |opt|
  opt.banner = "Usage: Couchbase Monitor COMMAND [OPTIONS]"
  opt.separator  ""
  opt.separator  "Commands"
  opt.separator  "     node: IP of one of the nodes in your cluster, format : {127.0.0.1}"
  opt.separator  "     bucket: Name of the bucket"
  opt.separator  ""
  opt.separator  "Options"

  opt.on("-n","--node NODE",String,"Node IP") do |node|
    options[:node] = node
  end

  opt.on("-h","--help",TrueClass,"help") do |help|
    options[:help] = help
  end
end

opt_parser.parse!

ip = options[:node]
help = options[:help]


if ip.nil? or help
puts opt_parser
raise abort
end

couchbaseAPI = CouchbaseMonitor.new(ip)
couchbaseAPI.check_node_status