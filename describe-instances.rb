#!/usr/bin/env ruby

require 'rubygems'
require 'yaml'
require 'aws-sdk'

config_file = "config.yml"
config = YAML.load(File.read(config_file))
AWS.config(config)

ec2 = AWS::EC2.new

puts("Instances")

ec2.instances.each do |i|
	puts(i.id+"	"+i.instance_type+"	"+i.status.to_s+"	"+i.availability_zone)
end

puts("Volumes")

ec2.volumes.each do |i|
	puts(i.id+"	"+i.status.to_s+"	"+i.size.to_s+"	"+i.availability_zone_name)
end
