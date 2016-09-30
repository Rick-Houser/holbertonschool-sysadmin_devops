#!/usr/bin/env ruby
require 'bundler/setup'
require 'optparse'
Bundler.require

# Load credentials from yaml file
creds = YAML.load_file("config.yaml", safe: true)

options = {}
OptionParser.new do |opt|
  opt.on('-a', '--action ACTION') { |o| options[:action] = o }
  opt.on('-i', '--instance_id INSTANCE') { |o| options[:instance] = o }
  opt.on('-h', '--help HELP') { |o| options[:help] = o }
  opt.on('-v', '--verbose VERBOSE') { |o| options[:verbose] = o }
end.parse!

case options[:action]
when "launch" # create the instance (and launch it)
  ec2 = Aws::EC2::Resource.new(
    region: 'us-west-2',
    credentials: Aws::Credentials.new(creds['access_key_id'],
    creds['secret_access_key']
  ))

  instance = ec2.create_instances({
    image_id: creds["image_id"],
    min_count: 1, # required
    max_count: 1, # required
    key_name: creds['key_pair'],
    security_group_ids: creds["security_group_ids"],
    instance_type: creds["instance_type"],
    placement: {availability_zone: creds["availability-zone"]}
  })
  # Wait for the instance to be created, running, and passed status checks
  check = ec2.client.wait_until(:instance_status_ok, {instance_ids: [instance[0].id]})

  ec2.instances.each do |i|
    if i.id == instance[0].id
      puts instance[0].id + "," + i.public_dns_name
    end
  end
  # puts check.reservations[0].instances[0].public_dns_name

when "stop"
  ec2 = Aws::EC2::Resource.new(region: 'us-west-2', credentials: Aws::Credentials.new(
    creds['access_key_id'],creds['secret_access_key'])
  )

  # Stop instance if it's state isn't already stopped
  ec2.instances.each do |i|
    if i.id == options[:instance] && i.state.name != "stopped"
      i.stop
      i.wait_until_stopped
    end
  end

when "start"
  ec2 = Aws::EC2::Resource.new(region: 'us-west-2', credentials: Aws::Credentials.new(
    creds['access_key_id'],creds['secret_access_key'])
  )

  # Start instance, wait for it to run, then show public dns
  ec2.instances.each do |i|
    if i.id == options[:instance]
      i.start
      i.wait_until_running
      puts i.public_dns_name
    end
  end

when "terminate"
  ec2 = Aws::EC2::Resource.new(region: 'us-west-2', credentials: Aws::Credentials.new(
    creds['access_key_id'],creds['secret_access_key'])
  )

  ec2.instances.each do |i|
    if i.id == options[:instance]
      i.terminate
    end
  end

else
  puts "Invalid action"
end
