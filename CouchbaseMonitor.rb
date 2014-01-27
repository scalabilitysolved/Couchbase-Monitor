#!/usr/bin/env ruby
require 'net/http'
require 'json'
require 'jsonpath'
require 'net/smtp'

class CouchbaseMonitor

  def initialize(ip)
    @url = "http://" + ip + ":8091/pools/nodes"
  end

  def http_request(url)
    uri = URI.parse(url)
    req = Net::HTTP::Get.new(uri)
    res = Net::HTTP.start(uri.host, uri.port) {|http|
      http.request(req)
    }
    JSON.parse(res.body)
  end

  def check_node_status
   json_response = http_request(@url)
   nodes_info = JsonPath.on(json_response,"$..nodes")
   nodes = JsonPath.on(nodes_info,"$..otpNode")
   statuses = JsonPath.on(nodes_info,"$..status")
   nodes.zip(statuses).each do |node,status|
     if(status == "healthy")
     puts node.gsub('ns_1@','') + " " + status
     end
   end
  end

end