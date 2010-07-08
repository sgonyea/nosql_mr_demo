#!/usr/bin/ruby 

require 'riak'
require 'csv'

begin
  case ARGV.size
  when 1 then   port = ARGV[0].to_i
  when 0 then   port = 8097
  else   raise  ArgumentException
  end
  raise ArgumentError if port == 0 or port > 65535
rescue NoMethodError, ArgumentError
  puts "Error: Invalid Arguments Specified"
  puts "Usage: #{$0} [port number, must be between 1 and 65535]"
  exit(1)
end

attributes  = [:from_ip, :ident, :user, :requested_at, :request, :status_code, :retr_obj_size, :referer, :user_agent]
log_pattern = /(\S*)\s*(\S*)\s*(\S*)\s*\[([^\]]*)\]\s*"([^"]*)"\s*(\S*)\s*(\S*)\s*"([^"]*)"\s*"([^"]*)"/

log_path    = "sample_data/raw-logs"

client      = Riak::Client.new(:port => port)
bucket      = client["mrtk"]

Dir.glob("#{log_path}/*").each do |log_file|

  File.open(log_file).each_line do |entry|
    log_matches = log_pattern.match(entry)
    record      = Hash[ [attributes, log_matches[1,9]].transpose ]

    key         = bucket.new
    key.data    = record
    key.store
  end
end
