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

attributes  = [:ip_num_from, :ip_num_to, :registry, :assigned_on, :ctry, :cntry, :country]
client      = Riak::Client.new(:port => port)
bucket      = client["iptoc", :keys => false]

=begin
Converts a numeric IP address into a string.  In reverse of:

1.2.3.4 = 16909060

1 * 256^3 (16777216)  = 16777216  +
2 * 256^2 (65536)     = 131072    +
3 * 256^1 (256)       = 768       +
4 * 256^0 (4)         = 4         =
                        --------
                        16909060
=end
def num_to_ip(num)
  octets    = []
  remainder = num.to_i
  3.downto(0).each do |pow|
    pow_256     = 256        ** pow
    quotient    = remainder.div pow_256
    remainder  -= quotient    * pow_256
    octets     << quotient
  end

  return octets.join('.')
end

CSV.foreach("sample_data/ip_to_country/IpToCountry01.csv") do |entry|
  record            = Hash[ [attributes, entry].transpose ]
  record[:ip_from ] = num_to_ip record[:ip_num_from ]
  record[:ip_to   ] = num_to_ip record[:ip_num_to   ]

  key       = bucket.new
  key.data  = record
  key.store
end

